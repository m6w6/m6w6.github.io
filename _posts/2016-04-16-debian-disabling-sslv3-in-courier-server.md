--- 
title: 'Debian: disabling SSLv3 in courier server' 
author: m6w6 
tags: 
- WTF 
- SYS
--- 

Debian wheezy (currently oldstable) ships courier-0.68 which was probably released on 2012. 
"Probably", because, head over to the [Courier website](http://www.courier-mta.org/) and 
try to find the NEWS/ChangeLog.

## The Problem

Anyway. Courier-0.68 has built-in openssl support on Debian and it initializes a SSL 
context the following way:

```c
ctx=SSL_CTX_new(protocol && strcmp(protocol, "SSL3") == 0
                ? SSLv3_method():
                protocol && strcmp(protocol, "SSL23") == 0
                ? SSLv23_method():
                TLSv1_method());

// ...
SSL_CTX_set_options(ctx, SSL_OP_ALL);

if (!ssl_cipher_list)
        ssl_cipher_list="SSLv3:TLSv1:HIGH:!LOW:!MEDIUM:!EXP:!NULL:!aNULL@STRENGTH";

SSL_CTX_set_cipher_list(ctx, ssl_cipher_list);
```

#### Some clarifications:

* `SSLv3_method` would **only** allow SSLv3
* `TLSv1_method` would **only** allow TLSv1.0
* `SSLv23_method` is "the general-purpose version-flexible SSL/TLS method"

So, if we do not want to limit ourselves to TLSv1.0, i.e. allow TLSv1.0, TLSv1.1 and TLSv1.2, 
we have to limit our protocol version support through other means.

Openssl-1.0.1 (remember, we're on Debian wheezy) does neither come with `TLS_method()` the 
generic TLS-only method, nor does it come with `SSL_CTX_set_min_proto_version` and we cannot 
disable SSLv3 with the cipher list if we also want to allow TLSv1.0.

## Solution 1: Upgrading to Jessie

What if we upgrade to Debian jessie (current stable)? Jessie ships courier-0.73, so let's see 
how SSL context intitialization looks there:

```c
options=SSL_OP_ALL;

method=((!protocol || !*protocol)
        ? NULL:
        strcmp(protocol, "SSL3") == 0
                ? SSLv3_method():
        strcmp(protocol, "SSL23") == 0
                ? SSLv23_method():
        strcmp(protocol, "TLSv1") == 0
        ? TLSv1_method():
#ifdef HAVE_TLSV1_1_METHOD
        strcmp(protocol, "TLSv1.1") == 0
        ? TLSv1_1_method():
#endif
#ifdef HAVE_TLSV1_2_METHOD
        strcmp(protocol, "TLSv1.2") == 0
        ? TLSv1_2_method():
#endif
        NULL);

if (!method)
{
        method=SSLv23_method();
        options|=SSL_OP_NO_SSLv2;
}

ctx=SSL_CTX_new(method);

// ...
SSL_CTX_set_options(ctx, options);

if (!ssl_cipher_list)
        ssl_cipher_list="SSLv3:TLSv1:HIGH:!LOW:!MEDIUM:!EXP:!NULL:!aNULL@STRENGTH";

SSL_CTX_set_cipher_list(ctx, ssl_cipher_list);
```

Jessie also comes with openssl-1.0.1, so the situation would not improve for our undertaking 
by upgrading to jessie.

## Solution 2: Augmenting SSL_CTX_new

What I came up with, is augmenting `SSL_CTX_new` and setting the desired `SSL_OP_NO_SSLv3` on 
each newly created SSL context.

```c
#include <stdio.h>
#include <dlfcn.h>
#include <openssl/ssl.h>

static void *lib;
static void *new_sym;
static void *opt_sym;

static void dl() {
        char *error;

        if (!lib) {
                lib = dlopen("libssl.so", RTLD_LAZY|RTLD_LOCAL);
                if (!lib) {
                        fprintf(stderr, "dlopen: %s\n", dlerror());
                        exit(1);
                }   
                dlerror();
        }   
    
        if (!new_sym) {
                *(void **) &new_sym = dlsym(lib, "SSL_CTX_new");
                if ((error = dlerror())) {
                        fprintf(stderr, "dlsym: %s\n", error);
                        dlclose(lib);
                        exit(1);
                }   
        }   

        if (!opt_sym) {
                *(void **) &opt_sym = dlsym(lib, "SSL_CTX_ctrl");
                if ((error = dlerror())) {
                        fprintf(stderr, "dlsym: %s\n", error);
                        dlclose(lib);
                        exit(1);
                }   
        }   
}

SSL_CTX *SSL_CTX_new(const SSL_METHOD *m) 
{
        SSL_CTX *ctx;

        dl();

        ctx = ((SSL_CTX *(*)(const SSL_METHOD*))new_sym)(m);

        if (ctx) {
                ((long (*)(SSL_CTX *, int, long, void*))opt_sym)(ctx, SSL_CTRL_OPTIONS, SSL_OP_ALL|SSL_OP_NO_SSLv2|SSL_OP_NO_SSLv3, NULL);
        }   
        return ctx;
}
```

This is the source of a tiny shared library pre-defining our `SSL_CTX_new`; to build like e.g.

`gcc -ldl -fPIC -shared -o preload.so preload.c`

It does the following:

* augments `SSL_CTX_new` with our own version, 
  i.e. whenever courier calls `SSL_CTX_new` our own version gets called
* when it's called the first time, it
 * `dlopen`'s libssl
 * fetches the addresses of the original `SSL_CTX_new` and `SSL_CTX_ctrl` 
   (which is the actual function `SSL_CTX_set_options` calls)
* calls the original `SSL_CTX_new` to actually create the SSL context
* calls `SSL_CTX_ctrl` on the new context with the options we want to set (`SSL_OP_NO_SSLv3`)
* returns the context to the caller

### Usage

Courier config files are basically shell scripts which set a environment variables, so we'll 
enable it as follows:

```sh
cd /etc/courier
cat >>esmtpd >>esmtpd-msa >>esmtpd-ssl \
    >>pop3d >>pop3d-ssl \
    >>imapd >>imapd-ssl \
    >>courierd <<EOF
LD_PRELOAD=/path/to/preload.so
EOF
```

Then restart each courier service.

### Verifying

Last, we have to verify that our solution actually works:

```sh
openssl s_client \
	-CApath /etc/ssl/certs/ \
	-starttls imap \
	-connect localhost:143 \
	-crlf -quiet -ssl3 \
	<<<LOGOUT
139690858608296:error:14094410:SSL routines:SSL3_READ_BYTES:sslv3 alert handshake failure:s3_pkt.c:1261:SSL alert number 40
139690858608296:error:1409E0E5:SSL routines:SSL3_WRITE_BYTES:ssl handshake failure:s3_pkt.c:599:
```

A bunch of errors. "Good"! :)

Let's see if we can still connect with TLSv1+:

```sh
openssl s_client \
	-CApath /etc/ssl/certs/ \
	-starttls imap \
	-connect localhost:143 \
	-crlf -quiet -tls1 \
	<<<LOGOUT
depth=2 ...
verify return:1
depth=1 ...
verify return:1
depth=0 ...
verify return:1
. OK CAPABILITY completed
* BYE Courier-IMAP server shutting down
LOGOUT OK LOGOUT completed
```

Awesome. Mission accomplished.

## Addendum

Here's my cipher list for the interested:

```sh
openssl ciphers -v 'HIGH+aRSA:+kEDH:+kRSA:+SHA:+3DES:!kSRP' \
  | awk '{ printf "%-28s %-8s %-8s %-18s %-16s\n",$1,$2,$3,$5,$6 }'
```

Which results in the following ciphers:

```
ECDHE-RSA-AES256-GCM-SHA384  TLSv1.2  Kx=ECDH  Enc=AESGCM(256)    Mac=AEAD
ECDHE-RSA-AES256-SHA384      TLSv1.2  Kx=ECDH  Enc=AES(256)       Mac=SHA384
ECDHE-RSA-AES128-GCM-SHA256  TLSv1.2  Kx=ECDH  Enc=AESGCM(128)    Mac=AEAD
ECDHE-RSA-AES128-SHA256      TLSv1.2  Kx=ECDH  Enc=AES(128)       Mac=SHA256
DHE-RSA-AES256-GCM-SHA384    TLSv1.2  Kx=DH    Enc=AESGCM(256)    Mac=AEAD
DHE-RSA-AES256-SHA256        TLSv1.2  Kx=DH    Enc=AES(256)       Mac=SHA256
DHE-RSA-AES128-GCM-SHA256    TLSv1.2  Kx=DH    Enc=AESGCM(128)    Mac=AEAD
DHE-RSA-AES128-SHA256        TLSv1.2  Kx=DH    Enc=AES(128)       Mac=SHA256
AES256-GCM-SHA384            TLSv1.2  Kx=RSA   Enc=AESGCM(256)    Mac=AEAD
AES256-SHA256                TLSv1.2  Kx=RSA   Enc=AES(256)       Mac=SHA256
AES128-GCM-SHA256            TLSv1.2  Kx=RSA   Enc=AESGCM(128)    Mac=AEAD
AES128-SHA256                TLSv1.2  Kx=RSA   Enc=AES(128)       Mac=SHA256
ECDHE-RSA-AES256-SHA         SSLv3    Kx=ECDH  Enc=AES(256)       Mac=SHA1
ECDHE-RSA-AES128-SHA         SSLv3    Kx=ECDH  Enc=AES(128)       Mac=SHA1
DHE-RSA-AES256-SHA           SSLv3    Kx=DH    Enc=AES(256)       Mac=SHA1
DHE-RSA-CAMELLIA256-SHA      SSLv3    Kx=DH    Enc=Camellia(256)  Mac=SHA1
DHE-RSA-AES128-SHA           SSLv3    Kx=DH    Enc=AES(128)       Mac=SHA1
DHE-RSA-CAMELLIA128-SHA      SSLv3    Kx=DH    Enc=Camellia(128)  Mac=SHA1
AES256-SHA                   SSLv3    Kx=RSA   Enc=AES(256)       Mac=SHA1
CAMELLIA256-SHA              SSLv3    Kx=RSA   Enc=Camellia(256)  Mac=SHA1
AES128-SHA                   SSLv3    Kx=RSA   Enc=AES(128)       Mac=SHA1
CAMELLIA128-SHA              SSLv3    Kx=RSA   Enc=Camellia(128)  Mac=SHA1
ECDHE-RSA-DES-CBC3-SHA       SSLv3    Kx=ECDH  Enc=3DES(168)      Mac=SHA1
EDH-RSA-DES-CBC3-SHA         SSLv3    Kx=DH    Enc=3DES(168)      Mac=SHA1
DES-CBC3-SHA                 SSLv3    Kx=RSA   Enc=3DES(168)      Mac=SHA1
```

Note, that courier actually does **not** support `ECDH` key exchange, but I didn't exclude it for 
the sake of simplicity for using the same cipher list for every server (e.g. web etc.)
