---
title: 'Update: overflow:auto in Mozilla'
author: m6w6
tags:
- WEB
---

If you want the page to scroll when the scrolling-enabled DIV has nothing to
scroll you'll have to wrap the contents of the _scrollMe_ function into the
following **if** statement:

```js
    function scrollMe(event)
    {
        if (event.currentTarget.scrollHeight >
            event.currentTarget.offsetHeight) {
            // ...
        }
    }
```

Have fun!
