---
title: Dropping server load with HTTP caching
author: m6w6
tags:
- PHP
---

Ever watched youself browsing e.g. a web forum?
Noticed that you viewed the same page several times?

Well, this means extraordinary **and** useless load for your server if there's
no caching mechanism implemented in the web application. Even if there is some
file or db cache you can still improve performance with implementing some http
cache.

The easiest way is using PEARs
[HTTP::Header](http://pear.php.net/package/HTTP_Header):

```php
require_once 'HTTP/Header/Cache.php';
// only cache a few seconds for frequently
// changing pages like a forum;
// Header_Cache will exit automatically with
// "HTTP 304 Not Modified" if the page is
// requested twice within 3 seconds
$cache = &new HTTP_Header_Cache(3, 'seconds');
$cache->sendHeaders();

// ... load from file/db cache
// ... or rebuild page
```

~~Probably the greatest caveat of using HTTP caching is, that our _beloved_
Internet Explorer with standard settings doesn't even send an request to the
server if it just **notices** a "Last-Modified" header (sic!), so one'd have
to press the reload button (without CTRL) that a new page is displayed after
the defined amount of time.~~

~~A dead end again? Decide yourself...~~

I finally managed to implement support for Internet Explorer in HTTP_Header
1.1.0 :D
