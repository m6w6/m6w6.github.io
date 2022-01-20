---
title: Class inheritance or Containers?
author: m6w6
tags:
- PHP
---

While talking with Daniel and Lorenzo about "Tree Reincarnated" I regularly
stumble across the question what approach to use to implement different
backends: **"Class inheritance or Containers?"**.

I personally feel that using the container approach leads to massive code
duplication, while using class inheritance avoids the most (_most_, because
there's no real multiple class inheritance in PHP).

## Container
```php
    class PublicAPI
    {
        var $container; // SpecificAPI

        function doSomething()
        {
            return $this->container->doSomething();
        }
    }
```

## Class Inheritance

```php
    class SpecificAPI extends PublicAPI
    {
        function doSomething()
        {
            // do something only this class needs to do
        }
    }
    ?>
```

So what do you feel about this topic and how you'd handle that?

## UPDATE

While looking again at Daniel's [nice diagram](http://devel.webcluster.at/~daniel/pear/Tree/docs/Tree.png?),
I feel like we've already reached the point where solving this problem with class
inheritence is impossible (despite using aggregate*() - you're right Lorenzo,
again :) have nice holidays! ).

Tree_Admin_Simple_MDB2 would have to extend Tree_Simple_MDB2 **and**
Tree_Admin_Simple_RDBMS...

Mike's arrived at the dead end, again ;)
