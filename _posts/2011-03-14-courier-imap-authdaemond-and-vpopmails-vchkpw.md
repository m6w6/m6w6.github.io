---
title: courier imap, authdaemond and vpopmails vchkpw
author: m6w6
tags: 
- WTF
- SYS
---

A few years ago, it was possible to have courier-imap update the open-smtp
relay file with it's authvchkpw module. This feature and thus imap-before-smtp
disappeared with the introduction of courier-authdaemond because the vchkpw
code of authdaemond does not have a chance to see the TCPREMOTEIP environment
variable.

I more or less lived with that, until a friend of mine got a new iphone...
well yeah, one of those i-geeks, and that gadget apparently only supports
imap, no pop.

To re-enable imap-before-smtp I wrote a little setuid wrapper, calling
vpopmails open_smtp_relay(). This wrapper has to replace the imapd command in
your courier-imap startup script and will exec imapd, after opening the smtp
relay, wile imap-login is still in place to authenticate via authdaemond's
vchkpw module.

```c
#include <unistd.h>  
#include <stdio.h>  
#include <sys/types.h>  
#include <vpopmail_config.h>  
#include <vauth.h>  
#include <vpopmail.h>  
  
#ifndef IMAPD  
#   define IMAPD "/usr/bin/imapd"  
#endif  
  
extern char **environ;  
  
int main(int argc, const char *argv[]) {  
    if (argc != 2) {  
        printf("1 NO argc != 2n");  
        return -1;  
    }  
  
    open_smtp_relay();  
    /* no need to chown vpopmail.vchkpw the open-smtp file  
     * because vchkpw used by qmail-pop3d is setuid root */  
  
    sleep(1);  
  
    if (setgid(VPOPMAILGID) || setuid(VPOPMAILUID)) {  
        printf("1 NO setuid/gid, getuid=%dn", getuid());  
        return -2;  
    }  
  
    execl(IMAPD, IMAPD, argv[1], NULL);  
  
    printf("1 NO exec %s failedn", IMAPD);  
    return -3;  
}
```

So while this worked to my satisfaction, I noticed that the tcp.smtp.cdb not
always contained the IPs of the open-smtp file:
```sh
$ for ip in $(sed -re 's/:.*//' < open-smtp); do   
    cdbget $ip < tcp.smtp.cdb > /dev/null   
        || echo "$ip is missing";   
    done
```

I also found out that, while the [vpopmail FAQ](http://www.inter7.com/vpopmail/FAQ.txt) is claiming 
that clearopensmtp is requesting locks on the open-smtp(.lock) file, the source does not read like
it would.  

I opened a [bug report](https://sourceforge.net/tracker/?func=detail&aid=3205655&group_id=85937&atid=577798)
for that issue, but as you might have already guessed, I'm running all of this
on an archaic debian box, where no upgrades are planned. So I came up with
another home-brewed solution:

```c
#include <unistd.h>  
#include <stdio.h>  
#include <sys/types.h>  
#include <vpopmail_config.h>  
#include <vauth.h>  
#include <vpopmail.h>  
#include <fcntl.h>  
  
extern int get_write_lock(FILE*);  
extern int lock_reg(int,int,int,off_t,int,off_t);  
#define unlock(F) lock_reg(fileno(F), F_SETLK, F_UNLCK, 0, SEEK_SET, 0)  
  
int main(int argc, const char *argv[]) {  
    FILE *fs_temp, *fs_smtp, *fs_lock = fopen(OPEN_SMTP_LOK_FILE, "w+");  
    time_t clear = RELAY_CLEAR_MINUTES * 60, now = time(NULL);  
    int cc = 0, rc = 0;  
  
    if (!fs_lock) {  
        return -1;  
    }  
    if (get_write_lock(fs_lock)) {  
        unlock(fs_lock);  
        fclose(fs_lock);  
        return -2;  
    }     
  
    if (!(fs_temp = fopen(OPEN_SMTP_TMP_FILE ".clear", "w"))) {  
        rc = -3;  
    } else if (!(fs_smtp = fopen(OPEN_SMTP_CUR_FILE, "r+"))) {  
        fclose(fs_temp);  
        rc = -4;  
    } else {  
        while (!rc && !feof(fs_smtp)) {  
            unsigned stime;  
            char sdata[256];  
  
            switch (fscanf(fs_smtp, "%255st%un", sdata, &stime)) {  
                case 2:  
                    if ((clear + stime) >= now) {  
                        fprintf(fs_temp, "%st%un", sdata, stime);  
                    } else {  
                        ++cc;  
                    }  
                    break;  
  
                default:  
                    rc = -5;  
                case EOF:  
                    break;  
            }  
        }  
        fclose(fs_smtp);  
        fclose(fs_temp);  
    }  
  
    if (!rc) {  
        if (cc) {  
            if (rename(OPEN_SMTP_TMP_FILE ".clear", OPEN_SMTP_CUR_FILE)) {  
                rc = -6;  
            } else if(update_rules()) {  
                rc = -7;  
            }  
        } else {  
            unlink(OPEN_SMTP_TMP_FILE ".clear");  
        }  
    }  
  
    unlock(fs_lock);  
    fclose(fs_lock);  
    return rc;
}
```

It's not the prettiest piece of code, but it helps.  
Well, maybe someone else running last-millenium software finds this useful

