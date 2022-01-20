---
title: Blank DELL on DisplayPort
author: m6w6
tags: 
- WTF 
- SYS
--- 

I've been struggling since ever with my DELL U3014 on the DisplayPort
saying there's no signal after a power cycle of the monitor.  
  
I just found a solution to bring the monitor back to life without rebooting
the box; just ssh into and issue:  

```shell  
$ DISPLAY=:0 xset dpms force off  
$ DISPLAY=:0 xset dpms force on  
```

I'm running Gnome3 on Arch Linux, so YMMV.  
