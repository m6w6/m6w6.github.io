---
title: pecl_http and sub-second timeouts
author: m6w6
tags: 
- PHP
---

Just a quick info, because I forget this again and again -- and it's not noted
in the [documentation](http://php.net/manual/en/ref.http.php) yet either.

Sub-second timeouts are supported by [libcurl](http://curl.haxx.se/libcurl/)
and thus by [pecl_http](http://pecl.php.net/pecl_http) -- yes but only if
libcurl is built with [(c-)ares](http://c-ares.haxx.se) support:

&lt;quote url="[curl_easy_setopt.html](http://curl.haxx.se/libcurl/c/curl_easy_setopt.html#CURLOPTTIMEOUTMS)">

> If libcurl is built to use the standard system name resolver, that portion
of the transfer will still use full-second resolution for timeouts with a
minimum timeout allowed of one second.
  
&lt;/quote>

