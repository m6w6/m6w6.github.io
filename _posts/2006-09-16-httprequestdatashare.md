---
title: HttpRequestDataShare
author: m6w6
tags:
- PHP
---

There are some news to talk about development of
[pecl/http](http://pecl.php.net/package/pecl_http).

I recently implemented an interface to the [curl-
share](http://curl.haxx.se/libcurl/c/libcurl-share.html) functionality in form
of an HttpRequestDataShare class.

This is what [reflection](http://php.net/reflection) will tell you about it:

```shell
mike@honeybadger:~/build/php-5.2-debug$ cli --rc HttpRequestDataShare  
Class [ <internal:http> class HttpRequestDataShare implements Countable ] {  
  
  - Constants [0] {  
  }  
  
  - Static properties [1] {  
    Property [ private static $instance ]  
  }  
  
  - Static methods [1] {  
    Method [ <internal> static public method singleton ] {  
  
      - Parameters [1] {  
        Parameter #0 [ <optional> $global ]  
      }  
    }  
  }  
  
  - Properties [4] {  
    Property [ <default> public $cookie ]  
    Property [ <default> public $dns ]  
    Property [ <default> public $ssl ]  
    Property [ <default> public $connect ]  
  }  
  
  - Methods [5] {  
    Method [ <internal, dtor> public method __destruct ] {  
  
      - Parameters [0] {  
      }  
    }  
  
    Method [ <internal, prototype Countable> public method count ] {  
  
      - Parameters [0] {  
      }  
    }  
  
    Method [ <internal> public method attach ] {  
  
      - Parameters [1] {  
        Parameter #0 [ <required> HttpRequest $request ]  
      }  
    }  
  
    Method [ <internal> public method detach ] {  
  
      - Parameters [1] {  
        Parameter #0 [ <required> HttpRequest $request ]  
      }  
    }  
  
    Method [ <internal> public method reset ] {  
  
      - Parameters [0] {  
      }  
    }  
  }  
}
```

Using this class, you can save a fair amount of time with name lookups which
the following example shows:
```php
$s = HttpRequestDataShare::singleton(true);  
print_r($s);  
for ($i = 0; $i < 10; ++$i) {  
    $r = new HttpRequest("http://www.google.com/");  
    $s->attach($r);  
    $r->send();  
    printf("%0.6fn", $r->getResponseInfo("namelookup_time"));  
    $s->detach($r);  
}  
```

Executing this script without dns data sharing enabled gives the following
results:
```shell
mike@honeybadger:~/build/php-5.2-debug$ cli  -d"http.request.datashare.dns=0"  
    ~/devel/http_rshare.php  
HttpRequestDataShare Object  
(  
    [cookie] =>  
    [dns] =>  
    [ssl] =>  
    [connect] =>  
)  
0.071296  
0.048798  
0.049598  
0.051545  
0.046258  
0.052318  
0.043769  
0.060753  
0.049168  
0.048568
```

...and with dns data sharing enabled:
```shell
mike@honeybadger:~/build/php-5.2-debug$ cli -d"http.request.datashare.dns=1"   
    ~/devel/http_rshare.php  
HttpRequestDataShare Object  
(  
    [cookie] =>  
    [dns] => 1  
    [ssl] =>  
    [connect] =>  
)  
0.051945  
0.000043  
0.000041  
0.000040  
0.000039  
0.000041  
0.000041  
0.000040  
0.000040  
0.000041
```

 **QED**

You can either use a per-process global datashare object created with
HttpRequestDataShare::singleton(true) or different instances for your
HttpRequest objects. Note that dns datasharing is used autmagically for
HttpRequestPool requests. Currently libcurl has implemented cookie and dns
data sharing only, trying to enable ssl session or connect sharing will raise
a warning.

Be sure to try it out; either directly from CVS or the next release, probably
being 1.3.0RC1.
