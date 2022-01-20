---
title: HTTP, CURL and stuff
author: m6w6
tags: 
- PHP
---

News, news, yawn.

Daniel Stenberg, head of the [cURL](http://curl.haxx.se) project,
[accepted](http://permalink.gmane.org/gmane.comp.web.curl.library/13439) a
patch for sub second time out support within libcurl. That means that you can
use float values as time outs with a millisecond resolution, as soon as you
use libcurl >= v7.16.2, that is, a minimum supported time out of 0.001 seconds
(which is **not** reasonable, just in case you wonder). On a side note, you
should build libcurl with [c-ares](http://daniel.haxx.se/projects/c-ares/) to
get working sub second DNS lookup time out support, AFAICT.

Clay Loveless, usually [killing people softly with his random strings](http://killersoft.com/randomstrings/), 
[mashing up APIs](http://mashery.com) or [providing compatibility libraries](http://code.google.com/p/phttp/), 
kindly asked me, if there were persistent connection support in
[pecl/http](http://pecl.php.net/package/pecl_http).

> _Is there an option in pecl_http that I'm overlooking that would be the
equivalent of STREAM_CLIENT_PERSISTENT?_

I was already about to answer that libcurl already does that all for us,
realizing that we destroy the used CURL handles at the end of each PHP request
at the latest, thus killing any alive connections. This happened about two
weeks ago, and pecl/http 1.5, of which RC1 had just been released, will
support per process persistent CURL handles. It can be enabled at compile time
only, as it's a quite intrusive feature. Yet I'm still unsure about the
implementation of this feature and it might change in the future to become a
bit more user-friendly.

To use it, there's nothing else to be done than tossing --enable-http-
persistent-handles at configure.

