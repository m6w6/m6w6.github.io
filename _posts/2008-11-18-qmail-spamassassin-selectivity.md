---
title: Qmail + SpamAssassin + selectivity
author: m6w6
tags: 
- SYS
---

Here's how my qmail-queue script looks like to selectively check messages with
SpamAssassin for non-relay clients only:

```sh
#!/bin/sh  
(if [ -n "${RELAYCLIENT+1}" -o `id -u` != 64011 ];   
    then cat -;   
    else /usr/bin/spamc -x -U /var/run/spamd/spamd.sock;   
fi) | /usr/sbin/qmail-queue.orig
```

For the records.
