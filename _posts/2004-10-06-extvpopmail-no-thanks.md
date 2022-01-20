---
title: ext/vpopmail? no thanks...
author: m6w6
tags: 
- PHP
---

If you ever thought about administering vpopmail through PHP, you most
probably already stumbled across the [vpopmail](http://pecl.php.net/vpopmail)
extension living in [PECL](http://pecl.php.net/), and know that making use of
it is rather kludgy...

In need of such a solution I've written a simple XML-RPC CGI service in C with
help of the [xmlrpc-c](http://xmlrpc-c.sourceforge.net/) library. I really
didn't think that it would be that easy, but it definitely was, considering
that I'm a C novice ;)

The following source will show that it's quite as simple as writing this XML-
RPC backend in PHP, and it's really fast.

### Update
There's now a source tarball available at: <http://dev.iworks.at/vpop-xmlrpc/>  
```c  
#include <sys/types.h>  
#include <stdio.h>  
#include <stdlib.h>  
#include <vauth.h>  
#include <vpopmail.h>  
#include <xmlrpc.h>  
#include <xmlrpc_cgi.h>

static xmlrpc_value *vpop_adduser(xmlrpc_env *env, xmlrpc_value *param, void *data)  
{
    char *user, *domain, *password, *fullname;  
    xmlrpc_bool rs;
    
    xmlrpc_parse_value(env, param, "({s:s,s:s,s:s,s:s,*})",  
        "user", &user,  
        "domain", &domain,  
        "password", &password,  
        "fullname", &fullname  
    );
      
    if (env->fault_occurred) {  
        return NULL;  
    }
    
    rs = vadduser(user, domain, password, fullname, 0) == 0 ? 1 : 0;
    
    return xmlrpc_build_value(env, "b", rs);  
}

static xmlrpc_value *vpop_deluser(xmlrpc_env *env, xmlrpc_value *param, void *data)  
{  
    char *user, *domain;  
    xmlrpc_bool rs;
    
    xmlrpc_parse_value(env, param, "({s:s,s:s,*})",  
        "user", &user,  
        "domain", &domain  
    );
    
    if (env->fault_occurred) {  
        return NULL;  
    }
    
    rs = vdeluser(user, domain) == 0 ? 1 : 0;
    
    return xmlrpc_build_value(env, "b", rs);  
}

static xmlrpc_value *vpop_passwd(xmlrpc_env *env, xmlrpc_value *param, void *data)  
{  
    char *user, *domain, *password;  
    xmlrpc_bool rs;
    
    xmlrpc_parse_value(env, param, "({s:s,s:s,s:s,*})",  
        "user", &user,  
        "domain", &domain,  
        "password", &password  
    );
    
    if (env->fault_occurred) {  
        return NULL;  
    }
    
    rs = vpasswd(user, domain, password, 0) == 0 ? 1 : 0;
    
    return xmlrpc_build_value(env, "b", rs);  
}

static xmlrpc_value *vpop_setquota(xmlrpc_env *env, xmlrpc_value *param, void *data)  
{  
    char *user, *domain, *quota;  
    xmlrpc_bool rs;
    
    xmlrpc_parse_value(env, param, "({s:s,s:s,s:s,*})",  
        "user", &user,  
        "domain", &domain,  
        "quota", &quota  
    );
    
    if (env->fault_occurred) {  
        return NULL;  
    }
    
    rs = vsetuserquota(user, domain, quota) == 0 ? 1 : 0;
    
    return xmlrpc_build_value(env, "b", rs);  
}

int main(int argc, char **argv)  
{  
    xmlrpc_cgi_init(XMLRPC_CGI_NO_FLAGS);
    
    xmlrpc_cgi_add_method_w_doc("vpop.adduser", &vpop_adduser, NULL,  
    "b:S", "Add a vpopmail user to a domain with password, fullname and quota.");  
    xmlrpc_cgi_add_method_w_doc("vpop.deluser", &vpop_deluser, NULL,  
    "b:S", "Delete a user from a domain.");  
    xmlrpc_cgi_add_method_w_doc("vpop.passwd", &vpop_passwd, NULL,  
    "b:S", "Change the password of a user in a domain.");  
    xmlrpc_cgi_add_method_w_doc("vpop.setquota", &vpop_setquota, NULL,  
    "b:S", "Set the quota of a user in a domain.");
    
    xmlrpc_cgi_process_call();
    
    xmlrpc_cgi_cleanup();  
    return 0;  
}  
```

