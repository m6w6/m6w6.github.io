---
title: Testing PHP extensions on Travis-CI
author: m6w6
tags: 
- PHP
---

Testing PECL extensions on Travis-CI has always been
cumbersome for me; build PHP in different versions and debug/threadsafe
flavors, install PECL dependencies and so on, which usually results in a mess
of command line scripts, repeated for every extension.  
  
Enter [travis-pecl](https://github.com/m6w6/travis-pecl).  
  
This tiny support bin comes with a Makefile and small PHP scripts to generate
the build matrix and check your package.xml file. It supports building PHP in
a wide variety of flavors, installing PECL dependencies from the PECL website
or from bundled [pharext](https://github.com/m6w6/pharext) packages and
running the testsuite with a comprehensive set of commands.  
  
Let's look at a few commands with a properly set up environment from the test
matrix:  

```yaml
env:  
 - PHP=5.6 enable_debug=yes with_iconv=yes enable_json=yes  
```
 
### Build PHP:  
```sh
make -f travis/pecl/Makefile php  
```
### Install a PECL dependency:  
```sh
make -f travis/pecl/Makefile pecl PECL=propro  
```
### Install a PECL dependency from a [pharext](https://github.com/m6w6/pharext) package, located in travis/:  
```sh
make -f travis/pecl/Makefile pharext/raphf-phpng  
```
### Build the currently checked out extension:  
```sh
make -f travis/pecl/Makefile ext PECL=http  
```
### Run the testsuite:  
```sh
make -f travis/pecl/Makefile test  
```

Finally, check out the [README](https://github.com/m6w6/travis-pecl/blob/master/README.md) 
and have a look at a couple of complete examples here:  

  * [ext-apfd/gen_travis_yml.php](https://github.com/m6w6/ext-apfd/blob/master/gen_travis_yml.php)
  * [ext-http/scripts/gen_travis_yml.php](https://github.com/m6w6/ext-http/blob/master/scripts/gen_travis_yml.php)
