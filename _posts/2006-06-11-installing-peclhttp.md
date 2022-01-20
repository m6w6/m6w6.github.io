---
title: Installing pecl_http
author: m6w6
tags: 
- PHP
---

As [pecl/http](http://pecl.php.net/package/pecl_http) 1.0 has finally been
released and I had noticed that it's been packaged already by several projects
like PLD, Gentoo and FreeBSD, I wanted to explain what one is going to gain
respectively lose by using the different build/configure options for the
extension.  

The help text of configure for pecl/http should look similar to the following:
```
  --enable-http           Enable extended HTTP support  
  --with-http-curl-requests[=LIBCURLDIR]  
                           HTTP: with cURL request support  
  --with-http-zlib-compression[=LIBZDIR]  
                           HTTP: with zlib encodings support  
  --with-http-magic-mime[=LIBMAGICDIR]  
                           HTTP: with magic mime response content type guessing  
  --with-http-shared-deps  HTTP: disable to not depend on extensions like hash,  
                                 iconv and session (when built shared)
```

If you link the extension source directory into your php tree, you should be
aware that these options show up on the end of the list of configure options
for **extensions** , not--as probably expected--in alphabetical order. This is
due to a recent change to use config9.m4 because the HTTP extension may depend
on several other PHP extensions ([hash](http://php.net/hash),
[iconv](http://php.net/iconv), [session](http://php.net/session)).


--with-http-curl-requests
: This configure option enables request functionality, uses
[libcurl](http://curl.haxx.se/libcurl/) and is _highly recommended_ to be
enabled. The minumum libcurl version required is 7.12.3. Debian/stable
currently ships 7.13.2 (no, this is not a typo).

--with-http-zlib-compression
: I think this is the most overseen/ignored option. Besides handling of
compressed HTTP messages, it also provides superior deflate/inflate
functionaly in regards to stability and performance compared to the standard
zlib extension. Both [http_deflate](http://dev.iworks.at/ext-http/http-functions.html.gz#http_deflate)()
/[http_inflate](http://dev.iworks.at/ext-http/http-functions.html.gz#http_inflate)() functions and
http.deflate/http.inflate stream filters are able to encode/decode all valid
gzip, zlib (AKA deflate) and raw deflated data. It requires at lieast libz
version 1.2.0.4, while Debian/stable ships 1.2.2, and is also _highly recommended_ to be enabled.

  

--with-http-magic-mime
: This option enables content type guessing for the
[HttpResponse](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpResponse) 
and [HttpMessage](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpMessage) 
classes. It's rather a gimmick and
thus not enabled by default. As there's no version information available for
libmagic, I don't even know which is the minimum version required but I guess
anything coming from a file-4.1x versioned package should work. If you get an
empty string as content type for payload which is obviously XML text, check
the magic.mime database you use for a broken **first** XML section. Comment
out everything except the SVG detection as other XML types and HTML is handled
further down the magic file (noticed on Debian systems). If you changed your
magic.mime database, don't forget to regenerate the precompiled version with
the `file -C` command.

  

--with-http-shared-deps
: This option controls whether pecl/http will depend on extensions built as
dynamically loadable modules. So, if e.g. ext/iconv has been compiled shared,
pecl/http relies on ext/iconv to be loaded when itself is going to be loaded.
This option is enabled by default.

 * _ext/hash_  
    pecl/http uses ext/hash to generate ETag hashes (else standard PHP MD5, SHA1 or CRC32).
 * _ext/iconv_  
    If ext/iconv is present, the [HttpQueryString](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpQueryString)  
    class provides an [xlate](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpQueryString_xlate)() method for charset transformation.
 * _ext/session_  
    [http_redirect](http://dev.iworks.at/ext-http/http-functions.html.gz#http_redirect)() can   
    automatically append session information to the redirect URL.
 * _ext/spl_  
    ext/spl cannot be built shared, so pecl/http always uses it if it's enabled.  
    [HttpMessage](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpMessage) and 
    [HttpRequestPool](http://dev.iworks.at/ext-http/http-functions.html.gz#HttpRequestPool) 
    classes implement the interface Countable provided by ext/spl.

