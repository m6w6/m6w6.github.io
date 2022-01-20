---
title: Introducing libcurls multi socket API
author: m6w6
tags: 
- PHP
---

So, finally a first beta of [pecl_http](http://pecl.php.net/package/pecl_http)
1.6 has been released.

This is the first version which supports [libcurl](http://curl.haxx.se/libcurl/)s 
[multi socketAPI](http://curl.haxx.se/libcurl/c/curl_multi_socket.html) introduced in 7.16
through libevent.


Here's a not very impressive comparison of the performance of the traditional
multi API vs. the new multi socket API:
```shell
mike@honeybadger:~/build/php-5.2-debug$ cli   
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php   
    -u http://honeybadger/empty.html  
  
>   1.134667s  
  
mike@honeybadger:~/build/php-5.2-debug$ cli   
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php   
    -u http://honeybadger/empty.html  
  
>   1.151088s  
  
mike@honeybadger:~/build/php-5.2-debug$ cli   
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php   
    -u http://honeybadger/empty.html  
  
>   1.131867s  
  
mike@honeybadger:~/build/php-5.2-debug$ cli   
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php   
    -u http://honeybadger/empty.html -e  
  
>   0.993878s  
  
mike@honeybadger:~/build/php-5.2-debug$ cli   
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php   
    -u http://honeybadger/empty.html -e  
  
>   0.998832s  
  
mike@honeybadger:~/build/php-5.2-debug$ cli   
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php   
    -u http://honeybadger/empty.html -e  
  
>   0.997121s
```

Above empty.html is, well, empty. The following test requests a 100k file:
```shell
mike@honeybadger:~/build/php-5.2-debug$ cli    
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php    
    -u http://honeybadger/100k.bin  
  
>   2.205190s  
  
mike@honeybadger:~/build/php-5.2-debug$ cli    
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php    
    -u http://honeybadger/100k.bin  
  
>   2.210525s  
  
mike@honeybadger:~/build/php-5.2-debug$ cli    
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php    
    -u http://honeybadger/100k.bin  
  
>   2.254281s  
  
mike@honeybadger:~/build/php-5.2-debug$ cli    
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php    
    -u http://honeybadger/100k.bin -e  
  
>   2.007220s  
  
mike@honeybadger:~/build/php-5.2-debug$ cli    
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php    
    -u http://honeybadger/100k.bin -e  
  
>   1.945564s  
  
mike@honeybadger:~/build/php-5.2-debug$ cli    
    ~/cvs/pecl/http/scripts/bench_select_vs_event.php    
    -u http://honeybadger/100k.bin -e  
  
>   1.969575s
```

So, apparently time savings are not huge, but noticable.

