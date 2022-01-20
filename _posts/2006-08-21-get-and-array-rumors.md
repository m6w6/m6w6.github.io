---
title: __get() and array rumors
author: m6w6 
tags: 
- PHP
---

There've been lots of rumors about overloaded array properties lately.

The following code
```php
class funky {  
  private $p = array();  
  function __get($p) {  
    return $this->p;  
  }  
}  
$o = new funky;  
$o->prop["key"] = 1;
```

will yield:

```shell
Notice: Indirect modification of overloaded property funky::$p has no effect
```

As arrays are the only complex types that are passed by value (resources don't
really count here) the solution to described problem is simple: use an object;
either an instance of stdClass or ArrayObject will do well, depending if you
want to use array index notation.

So the folloiwng code will work as expected, because the ArrayObject instance
will pe passed by handle:

```php  
class smarty {  
  private $p;  
  function __construct() {  
    $this->p = new ArrayObject;  
  }  
  function __get($p) {  
    return $this->p;  
  }  
}  
$o = new smarty;  
$o->prop["key"] = 1;  
```

I guess most of you already knew, but anyway... ;)

