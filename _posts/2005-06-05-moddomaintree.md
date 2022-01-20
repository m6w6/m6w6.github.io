---
title: mod_domaintree
author: m6w6
tags: 
- PHP
---

Friday evening I put together a tiny [Apache2](http://httpd.apache.org) module
simliar to mod_vhost_alias or mod_vd.
[mod_domaintree](http://cvs.iworks.at/co.php/mod_domaintree/mod_domaintree.c)
maps host names to a filesystem tree. While mod_vhost_alias and mod_vd seem to
be more flexible, they seem less useful to me.

mod_vhost_alias lets you define very precisely which part of the host name
maps to which directory but adds odd underscores if the part (number) of the
hostname does not exist.

mod_vd lets you define the numerical amount of host name parts to strip.

But I **don't want to strip always** one part of the host name like "www" \- I
just want to strip the first part of the host name (i.e. www) if it occurs in
the sent hostname.

If you want to try it out, there's nothing more to do then (w)getting
[it](http://cvs.iworks.at/co.php/mod_domaintree/mod_domaintree.c?p=1) and
running
```shell
sudo /usr/sbin/apxs2 -a -i -c mod_domaintree.c
```
## Sample Configuration:
```apache
DomainTreeEnabled On  
DomainTreeMaxdepth 25  
DomainTreeStripWWW On  
DomainTreePrefix /sites  
DomainTreeSuffix /html
```

### Mapped Hosts: (accepting "www" as prefix if DomainTreeStripWWW is enabled)

  * company.co.at
  * sub1.company.co.at
  * sub2.company.co.at
  * organisation.or.at
  * example.at
  * example.com

### Resulting Filesystem Tree:
```shell
 /sites  
    +- /at  
    |    +- /co  
    |    |    +- /company  
    |    |        +- /html  
    |    |        +- /sub1  
    |    |        |    +- /html  
    |    |        +- /sub2  
    |    |            +- /html  
    |    +- /or  
    |    |    +- /organisation  
    |    |        +- /html  
    |    +- /example  
    |        +- /html  
    +- /com  
        +- /example  
            +- /html
```

PS: I was very suprised how easy it is to build a simple module for Apache (if
you have some templates to look at though). :)
