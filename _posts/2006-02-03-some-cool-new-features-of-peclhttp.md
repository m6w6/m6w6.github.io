---
title: Some cool new features of pecl/http
author: m6w6
tags: 
- PHP
---

[PECL::HTTP](http://pecl.php.net/package/pecl_http) version 0.22 has been
released this morning, and I want to point at some features which have been
added to the extension since I last blogged about it.

Incremental zlib (de)compressors were added in form of two classes,
[HttpDeflateStream](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpDeflateStream) and
[HttpInflateStream](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpInflateStream). I hope the names say it all ;)

Another class, that might seem a bit odd at a quick glance, is
[HttpQueryString](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpQueryString). It's a great tool to realize "paging" or
sites with lots of rewrite rules AKA "pretty urls".

The class [HttpMessage](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpMessage) has finally got its iterator interface to move
up the message chain in a more convenient way. Messages can now be
[detached](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpMessage_detach) and
[prepended](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpMessage_prepend) from/to the message chain.

Thanks to [Ilia](http://ilia.ws) you can now retrieve the raw request and
response messages sent resp. received by an
[HttpRequest](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpRequest) instance.

The function [http_build_url](http://dev.iworks.at/ext-http/http-functions.html.gz#http_build_url) is now the most versatile and powerful
utility to handle URLs (sorry for the lack of docs). Please [tell
me](mailto:mike@iworks.at) if you don't think so ;)

