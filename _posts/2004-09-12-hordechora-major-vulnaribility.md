---
title: HORDE::Chora major vulnaribility
author: m6w6
tags: 
- PHP
---

If you're running Hordes Chora **1.2** you should immediately upgrade your
Horde installation or temporarily disable CVS access through HTTP.


### Unfiltered $_GET as shell argument  
On a quick glance scripts like _diff.php_ seem to use unfiltered $_GET
parameters as shell command arguments, which will allow any remote user to
execute any command as webserver user.

A request like ~~<http://cvs.your.host/>... ~~ will reveal the process list of
the machine.

