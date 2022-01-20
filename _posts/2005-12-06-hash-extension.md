---
title: Hash Extension
author: m6w6
tags: 
- PHP
---

If you didn't notice yet, there's a new, seemingly unimpressive, nevertheless
very useful, extension on the horizon, namely
ext/[hash](http://pecl.php.net/package/hash).

The initial version, proposed by Sara and Stefan -and it seems that Rasmus had
his hands on it too- already featured the most common algorithms, and it has
recently been extended to support now fairly every algo which libmhash
provides.

There's not been any public release yet, which means you'd need to build from
CVS. [pecl4win](http://pecl4win.php.net) though, already provides fresh
modules for Windows users.

### It's usage is simple and intuitive
Hashing a string:
```php  
echo hash('sha384', 'The quick brown fox jumps over the lazy dog');  
```  
Hashing a file:
```php
echo hash_file('md5', 'release-1.0.tgz');  
```
There's also an incremental interface available.

The recently released version of the [HTTP
extension](http://pecl.php.net/package/pecl_http) now uses the HASH extension
instead of libmhash for generating its etag hashes.

## Update:
Just in case you missed, Sara released
[pecl/hash](http://pecl.php.net/package/hash) today.  
Check it out -- It'll be bundled with PHP-5.1.2!

