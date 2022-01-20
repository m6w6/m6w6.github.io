---
title: Cookie Handling
author: m6w6
tags: 
- PHP
---

I noticed some _weirdance_ about how libcurl and thus pecl/http handles
cookies.

I had to implement some changes which are only in CVS for now and which I'm
going to outline here:

```php  
$r = new HttpRequest("http://www.google.at/");  
$r->recordHistory = true;  
// we don't care about cookies by default  
// enable automatic recognition of cookies  
$r->enableCookies();  
$r->send();  
// received cookies will be sent on the next request  
$r->send();  
// reset those "auto" cookies  
// this needs at least libcurl >= v7.14.1  
$r->resetCookies();  
$r->send();  
echo $r->getHistory()->toString(true);  
```

Beware that all this does not affect custom cookies set with
[HttpRequest::setCookies](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpRequest_setCookies)() and
[HttpRequest::addCookies](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpRequest_addCookies)(). 
Custom cookies can always be unset by calling HttpRequest::setCookies().

A final note on using the **cookiestore** option:

```php
$r = new HttpRequest("http://www.google.at/");  
// load and save cookies from /tmp/cookies.txt  
// if 'cookiesession' is TRUE, session cookies  
// won't be loaded from the cookiestore  
$r->setOptions(array(  
    "cookiesession" => TRUE,  
    "cookiestore" => "/tmp/cookies.txt")  
);  
$r->send();  
```

Note that using the cookiestore automatically enables libcurls cookie engine.

