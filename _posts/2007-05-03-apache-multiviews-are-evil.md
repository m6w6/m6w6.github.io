---
title: Apache MultiViews are evil
author: m6w6
tags: 
- WTF 
- WEB
---

Suppose you've got a similar setup to:

```apache
RewriteEngine On  
RewriteBase /  
  
RewriteCond %{REQUEST_FILENAME} -f [OR]  
RewriteCond %{REQUEST_FILENAME} -d  
RewriteRule .* - [QSA,L]  
  
RewriteRule ^network/?(w+)?$ network.php?path=$1
```

Apache will expand e.g. "network/foo/bar" to "network.php/foo/bar" which won't
be expanded to "network.php?f=" because it --of course-- exists (RewriteCond -f).

Evil! :)

