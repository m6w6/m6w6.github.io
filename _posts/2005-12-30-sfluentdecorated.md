---
title: s/fluent/decorated/
author: m6w6
tags: 
- PHP
---

I've [read](http://www.achievo.org/blog/archives/25-The-danger-of-Fluent-interfaces.html) 
[some](http://andigutmans.blogspot.com/2005/12/fluent-interfaces.html) 
[posts](http://paul-m-jones.com/blog/?p=188) about "fluent interfaces" and 
I have to agree that it's a bad idea to sacrifice a reasonable
API to be able to write english code.

It's anyway possible to accomplish that to some extent on a need-by-need basis
with a class of only 20 lines of code:

```php  
class ReturnThisDecorator  
{  
    private $object;  
    public $result;  
  
    function __construct($object)  
    {  
        if (is_object($object)) {  
            $this->object = $object;  
        } else {  
            throw new InvalidArgumentException(  
                "Expected an object as argument"  
            );  
        }  
    }  
  
    function __call($method, $params)  
    {  
        $this->result = call_user_func_array(  
            array($this->object, $method), $params  
        );  
        return $this;  
    }  
}  
  
$sms = new ReturnThisDecorator(new SMS);  
echo $sms->from('...')->to('...')->message('...')->send()->result;  
```
