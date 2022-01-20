---
title: HttpRequestPool in PECL::HTTP
author: m6w6
tags: 
- PHP
---

I just checked in a first working version of HttpRequestPool into CVS.  
It's curl_multi that's doing its job underneath and is used tp send several
HttpRequests at once.
```php  
$urls = array(  
    'http://www.php.net/',  
    'http://pear.php.net/',  
    'http://pecl.php.net/'  
);  
  
$pool = new HttpRequestPool;  
foreach ($urls as $url) {  
    $pool->attach(new HttpRequest($url, HTTP_METH_HEAD));  
}  
  
try {  
    $pool->send();  
    foreach ($pool as $r) {  
        $status = $r->getResponseCode();  
        printf("%-20s is %sn",  
            $r->getUrl(),  
            $status == 200 ? "ALIVE" : "NOT OK ($status)"  
        );  
    }  
} catch (HttpException $ex) {  
    echo $ex;  
}  
```
