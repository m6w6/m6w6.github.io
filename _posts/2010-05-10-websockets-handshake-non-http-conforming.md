---
title: WebSockets Handshake non HTTP conforming?
author: m6w6
tags: 
- WTF 
- PHP 
- WEB
---


While skimming through the new [HTML5 WebSocket draft](http://dev.w3.org/html5/websockets/), 
I noticed the following exemplar HTTP message demonstrating the client message of a WebSocket handshake:

```http
GET /demo HTTP/1.1
Host: example.com
Connection: Upgrade
Sec-WebSocket-Key2: 12998 5 Y3 1  .P00
Sec-WebSocket-Protocol: sample
Upgrade: WebSocket
Sec-WebSocket-Key1: 4 @1  46546xW%0l 1 5
Origin: http://example.com

^n:ds[4U
```

To me this looks non conforming to the [HTTP
spec](http://www.w3.org/Protocols/rfc2616/rfc2616.html) due to the lack of an
indicator that the request contains a message body.

Quoting [the 4th paragraph of section 4.3 of
RFC2616](http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.3):

> The **presence of a message-body** in a request **is signaled** by the
inclusion of a **Content-Length or Transfer-Encoding header** field in the
request's message-headers. A message-body MUST NOT be included in a request if
the specification of the request method (section 5.1.1) does not allow sending
an entity-body in requests. A server SHOULD read and forward a message-body on
any request; if the request method does not include defined semantics for an
entity-body, then the message-body SHOULD be ignored when handling the
request.

Huh?

