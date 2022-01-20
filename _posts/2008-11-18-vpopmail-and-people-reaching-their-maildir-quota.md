---
title: Vpopmail and people reaching their maildir quota
author: m6w6
tags: 
- SYS
---

This tiny program lists all users of a domain with a maildir quota usage above
90%.

```c
#include <stdio.h>  
#include <stdlib.h>  
#include <unistd.h>  
#include <string.h>  
  
#include <pwd.h>  
#include <errno.h>  
  
#include <vpopmail.h>  
#include <vauth.h>  
  
int main(int argc, char **argv) {  
    struct vqpasswd *user;  
    char dir[1024];  
    uid_t uid;  
    gid_t gid;  
    int offset_counter = -1, sort = 1, usage;  
  
    if (argc != 2) {  
        fprintf(stderr, "Usage: %s <domain>n", argv[0]);  
        return EXIT_FAILURE;  
    }  
    if (vget_assign(argv[1], NULL, 0, &uid, &gid) == NULL) {  
        fprintf(stderr, "domain '%s' does not existn", argv[1]);  
        return EXIT_FAILURE;  
    }  
    if (setgid(gid) || setuid(uid)) {  
        fprintf(stderr, "could not setuid/setgid to %d:%dn", uid, gid);  
        return EXIT_FAILURE;  
    }  
  
    while (NULL != (user = vauth_getall(argv[1], !++offset_counter, sort))) {  
        if (strcmp(user->pw_shell, "NOQUOTA")) {  
            snprintf(dir, sizeof(dir), "%s/Maildir", user->pw_dir);  
            usage = vmaildir_readquota(dir,  
                format_maildirquota(user->pw_shell));  
  
            if (usage >= 90) {  
                printf("%s %s %dn", user->pw_name, user->pw_shell, usage);  
            }  
        }  
    }  
  
    return EXIT_SUCCESS;  
}
```

