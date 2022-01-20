---
title: Upgrading to 5.2
author: m6w6
tags: 
- PHP
---

So I finally came around to upgrade to PHP 5.2 (I was running 4.4 on the
production server until now). I know, what a shame! :)

Anyway the only issue I really had, in spite testing the code really well over
time, was with class_exists() and millions of warnings becaus of a missing
__autoload(). I blame the people who introduced the second parameter to
class_exists() **and** changing the default behaviour at the very same moment.
Actually, it was an annoying but rather easy to fix compatibility brake.

APC in conjunction with PHP-5.2 seems to work very well either, it even feels
a lot less memory exhaustive than running APC+PHP-4.

Ah yes, just on a side note, I also upgraded to Apache-2.2 in the same run.
Somehow I now have a warm and fuzzy feeling running this up-to-date software,
it really was already like a brinck in my stomach. Anyway, what's left is to
migrate from the Apache module to the FastCGI SAPI and switching to the worker
MPM... but I'm done already.

