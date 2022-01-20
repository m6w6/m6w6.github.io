---
title: ext/apr - exercise or joke?
author: m6w6
tags:
- PHP
---

Well yes, it started as an exercise (and others thought it is a joke) ;)

My intention was to export apr_md5_encode() to php which generates MD5
password hashes similar to those found in .htpasswd files. [PEARs
File_Passwd](http://pear.php.net/package/File_Passwd) already does that, but
with plain vanilla PHP - generating one password takes about 0.2 seconds and
more.

Currently I'm trying to make apr_threads usable - wouldn't threads in PHP be
cool? Yes, they'd definitly be :) It's just a segfault away from working ;)

```php
    class Thread1 extends APR_Thread {
        function run() {
            // do some work
        }
    }
    class Thread2 extends APR_Thread {
        function run() {
            // do some concurrent work
        }
    }
    new Thread1;
    new Thread2;
```

Thanks to Derick, Sara and the whole php.pecl gang - I wouldn't have managed
to get that far without their tremendous help!
