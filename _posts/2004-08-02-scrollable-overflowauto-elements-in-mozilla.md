---
title: Scrollable overflow:auto Elements in Mozilla
author: m6w6
tags:
- WEB
---

Doing some extensive Javascript work lately, I managed to make HTML elements
styled with //overflow:auto// scrollable in Mozilla.



Just place this snippet at the bottom of your page with DIV elements that have
scroll as classname:


```js
// enable scrolling for overflow:auto elements in Mozilla
function scrollMe(event)
{
  var st = event.currentTarget.scrollTop;
  st += (event.detail * 12);
  event.currentTarget.scrollTop = st < 0 ? 0 : st;
  event.preventDefault();
}
if (document.body.addEventListener) {
  var divs = document.getElementsByTagName('DIV');
  for (var d in divs) {
    if (divs[d].className && divs[d].className == 'scroll') {
      try {
        divs[d].addEventListener(
             'DOMMouseScroll', scrollMe, false);
      } catch (ex) {}
    }
  }
}
```


I already posted a feature request to embed something similar in pearweb.
