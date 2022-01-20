---
title: pecl/http update
author: m6w6
tags: 
- PHP
---

Yeah, you guessed, version 0.23 of
[pecl/http](http://pecl.php.net/package/pecl_http) has been released, and it's
time for a feature update ;)

###  Cookies

[http_parse_cookie](http://dev.iworks.at/ext-http/http-functions.html.gz#http_parse_cookie)() has been reimplemented (and
HttpRequest::getResponseCookie() has been moved to
[HttpRequest::getResponseCookies](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpRequest_getResponseCookies)(). 
After revisiting the
original Netscape [draft](http://wp.netscape.com/newsref/std/cookie_spec.html)
and the two [cookie](ftp://ftp.rfc-editor.org/in-notes/rfc2109.txt)
[RFCs](ftp://ftp.rfc-editor.org/in-notes/rfc2965.txt) it was pretty obvious
that the previous implementation was pretty bogus.

Now it works as follows:

```php  
http_parse_cookie("cookie1=value; cookie2=\"1;2;3;4\"; path=/");  
/*  
stdClass Object  
(  
    [cookies] => Array  
        (  
            [cookie1] => value  
            [cookie2] => 1;2;3;4  
        )  
  
    [extras] => Array  
        (  
        )  
  
    [flags] => 0  
    [expires] => 0  
    [path] => /  
    [domain] =>  
)  
*/  
```

As you can see, a cookie line can have several name/value pairs. The standard
additional fields like expires, path etc. are recogniced automatically. The
RFCs, though, define some other standard extra elements, here's where the
third parameter of http_parse_cookie() plays in:

```php
http_parse_cookie("cookie1=value; cookie2=\"1;2;3;4\"; comment=\"none\"; path=/",  
    0, array("comment"));  
/*  
stdClass Object  
(  
    [cookies] => Array  
        (  
            [cookie1] => value  
            [cookie2] => 1;2;3;4  
        )  
  
    [extras] => Array  
        (  
            [comment] => none  
        )  
  
    [flags] => 0  
    [expires] => 0  
    [path] => /  
    [domain] =>  
)  
*/
```

If "comment" wouldn't have been specified as an allowed extra element, it
would just have been recognized as another cookie.  
IF you pass HTTP_COOKIE_PARSE_RAW as second parameter to http_parse_cookie(),
no urldecoding is performed.  
The flags in the return value is a bitmask of HTTP_COOKIE_SECURE and
HTTP_COOKIE_HTTPONLY.

###  Messages

Some users pointed me to the fact that neither
[HttpMessage](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpMessage) 
nor [HttpRequest](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpRequest) 
provide accessors to the HTTP
response reason phrase AKA status text. They've been added in form of
[HttpMessage::getResponseStatus](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpMessage_getResponseStatus)() and
[HttpRequest::getResponseStatus](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpRequest_getResponseStatus)().

Some might have wondered why [HttpMessage](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpMessage)s are 
chained in kind of a reverse order. Well, that has internal reasons, caused by how we retreive the data from
[libcurl](http://curl.haxx.se) and how the message parser works. Anyway
there's now [HttpMessage::reverse](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpMessage_reverse)() 
which reorders the messages in a more intuitive chronical way:

```php
$msg = new HttpMessage(  
"GET / HTTP/1.1  
HTTP/1.1 302 Found  
Location: /foo  
GET /foo HTTP/1.1  
HTTP/1.1 200 Ok");  
foreach ($msg as $m) echo $m;  
foreach ($msg->reverse() as $m) echo $m;  
/*  
HTTP/1.1 200 Ok  
GET /foo HTTP/1.1  
HTTP/1.1 302 Found  
Location: /foo  
GET / HTTP/1.1  
  
GET / HTTP/1.1  
HTTP/1.1 302 Found  
Location: /foo  
GET /foo HTTP/1.1  
HTTP/1.1 200 Ok  
*/  
```

Note, though, that [HttpMessage::toString](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpMessage_toString)(true) automatically prepends parent
messages, i.e. gives the latter result.

###  Requests

For servers that don't urldecode cookies, a new option has been added, named
"encodecookies", which omits urlencoding cookies if set to FALSE.

Similarily to the "lastmodified" request option, there's now an "etag" option
working along the same lines.

[HttpRequest::getHistory](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpRequest_getHistory)() 
now returns a real HttpMessage property, which measn that this message chain is no longer immutable to
changes made by the user.

If a request fails for some reason, you should now be able to get the error
message through [HttpRequest::getResponseInfo](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpRequest_getResponseInfo)("error").

