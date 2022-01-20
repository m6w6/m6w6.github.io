---
title: PECL::HTTP 0.20.0 outta door
author: m6w6
tags: 
- PHP
---

Version 0.20.0 of [pecl/http](http://pecl.php.net/package/pecl_http) has been
released!  
This is considered the most stable and friggin best release so far ;) so
you're really encouraged to upgrade.

### Release notes follow:

* Request functionality requires libcurl >= 7.12.3 now  
+ Added 'bodyonly' request option  
+ Added IOCTL callback for cURL  
+  Added ssl_engines array and cookies array to the request info array  
+ Added http_parse_cookie() to parse Set-Cookie headers  
- Renamed http_connectcode to connect_code in the request info array  
- Enable "original headers" previously stripped off by the  
  message parser:  
    o X-Original-Transfer-Encoding (Transfer-Encoding)  
    o X-Original-Content-Encoding (Content-Encoding)  
    o X-Original-Content-Length (Content-Length)  
- RequestExceptions thrown by HttpRequestPool::__construct() and  
  send() are now wrapped into the HttpRequestPoolException  
  object's $exceptionStack property  
- Removed http_compress() and http_uncompress()  
  (http_deflate/inflate ambiguity)  
* Fixed bug which caused GZIP encoded archives to be decoded  
* Fixed bug with DEFLATE encoded response messages  
* Fixed several memory leaks and inconspicuous access violations  
* Fixed some logical errors in the uri builder

