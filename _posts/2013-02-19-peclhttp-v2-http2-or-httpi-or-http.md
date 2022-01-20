---
title: pecl_http-v2 - http2 or httpi or http-*
author: m6w6
tags: 
- PHP
---

I'm pondering to release v2 of pecl_http with a different
extension name than "http", but I cannot agree with myself what's worse:  

### http2

This might be confused with HTTP/2.0  

### httpi

There's mysqli following this approach, but I think this is pretty odd.  

### Split it up

Split the package up in several smaller sub-packages, like:

  * http-common
  * http-env
  * http-client
  * http-client-curl
  * etc.

If you have an opinion, or maybe even a better idea, please leave a comment.
