---
title: imap_savebody()
author: m6w6
tags: 
- PHP
---

If you -like me- were suffering from being unable to load big attachments
through ext/imap because of PHPs memory limit, the new imap_savebody()
function should be what you were looking for. It adds the ability to save any
section (full mail, too) of a mail message to a file or stream.

Adding it implied a non-trivial change to ext/imap, so if you encounter any
new problems -with f.e. imap_fetchbody()- speak up ASAP, please! ;)
