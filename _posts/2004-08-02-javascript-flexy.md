---
title: Javascript & Flexy
author: m6w6
tags:
- PHP
---

If you ever used [Flexy](http://pear.php.net/package/HTML_Template_Flexy),
which I consider a really great TE, you have most probably already stumbled
across Flexy's inability to step into `<script>` blocks.

A really easy method to overcome this problem is to define scriptOpen and
scriptClose properties in your base objects outputted by Flexy:

```php
<?php
class FlexyObject {
  var $scriptOpen = "\n<script type="text/javascript"> <!--\n";
  var $scriptClose = "\n//--> </script>n";
  var $scriptData = "var foo = 'bar';";
}
```

Outputting above object with the following template wont work:

```html
<html>
<script type="text/javascript">
  {scriptData:h}
</script>
</html>
```

Instead:

```html
<html>
{scriptOpen:h}
  {scriptData:h}
{scriptClose:h}
</html>
```

...works like a charm... ;)

Alan said, Flexy wont step into Javascript blocks because that caused
massive problems with the Smarty convertor...
