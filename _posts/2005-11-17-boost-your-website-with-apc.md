---
title: Boost your Website with APC
author: m6w6
tags: 
- PHP
---

Two weeks ago I plugged [APC](http://pecl.php.net/package/APC) onto my main
customers site, and I'm really satisfied by it now. I already tried it some
time ago, but back then it had some problems with PEARs Quickforms and
similiar heavy OO code, but those problems are fixed for about 90% now, some
8% can be easily fixed by reordering **require** statements and the like and
finally the remaining ~2% are going to be fixed by Rasmus in the foreseeable
future.

Note that I'm using APC with Debians PHP-4.3.10 and Apache2 package, which
proofs a lot IMO ;) and there shouldn't be much that hinders you from trying
it too!

Here's a very simple instruction to boost your PHP enabled webserver:
```shell    
~$ pear download pecl/apc  
~$ tar xzf APC-3.0.8.tgz  
~$ rm -f package.xml  
~$ cd APC-3.0.8  
~/APC-3.0.8$ /usr/bin/phpize  
~/APC-3.0.8$ ./configure --with-php-config=/usr/bin/php-config   
    --enable-apc --enable-apc-mmap  
~/APC-3.0.8$ make all  
~/APC-3.0.8$ sudo make install
```

APC is now installed somewhere in /usr/lib/php.

Some lines to add to php.ini:
```ini    
extension=apc.so  
  
[apc]  
apc.enabled = 1  
apc.cache_by_default = 1  
apc.shm_size = 32  
apc.num_files_hint = 500  
apc.mmap_file_mask = /tmp/apc.XXXXXX
```

If you want to cache only a certain virtual host, set apc.cache_by_default to
0 in php.ini and add the respective php_admin_value to your `<VirtualHost>`
directive for the vhost.

The package also contains a useful status script, just copy the shipped
apc.php to your document root. You'll see how the usage of the SHM segment
grows by time, and after some time you'll also see what settings to use for
apc.num_files_hint and apc.shm_size when the whole site is cached.

Sean recently added some [APC docs](http://docs.php.net/apc), too!

Quod est demonstrandum, Website boosted! ;)
