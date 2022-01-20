---
title: PECL HTTP, lap 12
author: m6w6
tags: 
- PHP
---

Today I released [PECLs HTTP extension version 0.12](http://pecl.php.net/package/pecl_http/0.12.0)

A lot of work and fixes have gone into it, and I hope it's becoming stable
even this century ;)

Major changes are a general API cleanup where AuthBasic hooks have been
removed and many HttpRequest methods have been sanitized.

The HttpResponse class should now work with PHP5 as a webserver module as well
and should not any longer have hard dependencies on ext/session and ext/zlib.

Additionally, if you have libmhash (note: not necessarily ext/mhash) you can
choose a hashing algorithm provided by libmhash to generate your ETags, which
is done through the following INI setting: http.etag_mode = MHASH_SHA256
(MHASH_SHA256 is an example and can be replaced by any MHASH constant **if**
you have ext/mhash).

The message and header parsers have been vastly improved to be able to parse
(in principle invalid) messages and headers that only have a single LF instead
of CRLF.

And last but not least it should again flawlessly build for PHP4.

So far, have fun and be sure to check it out! :)

