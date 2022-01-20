---
title: Javascript delaying
author: m6w6
tags: 
- WEB
---

In need of executing Javascript after the page has loaded, or something else
has been initialized I came up with a simple but useful tiny "Delayer":

```js
/**  
 * @param handler a callback accepting Delayer.dispatch as argument  
 */  
function Delayer(handler) {  
    var self = this;  
  
    this.dispatch = function() {  
        for (var i = 0; i < self.length; ++i) {  
            console.log("running delayed init "+i+": "+self[i]);  
            self[i]();  
        }  
    };  
  
    if (typeof handler == "function" || handler instanceof Function) {  
        handler(this.dispatch);  
    }  
}  
  
Delayer.prototype = Array.prototype;
```

It can be initialized the following way:
```js
/* e.g. with jQuery */  
window.delayedInits = new Delayer($(document).ready);  
/* e.g. with Facebook */  
window.fbDelayedInits = new Delayer(function(dp){window.fbAsyncInit = dp;});
```

Then you push your work the usual way:
```js
delayedInits.push(function() {alert("Hello, delayed!");});
```
