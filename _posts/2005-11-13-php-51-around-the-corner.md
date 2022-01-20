---
title: PHP-5.1 around the corner
author: m6w6
tags: 
- PHP
---

Here's a tidied up excerpt of the current NEWS file with all relevant changes
since PHP 5.0, which may help on the decision to upgrade (even from PHP 4 :))

###  Fixes

  * More than 350

###  Changes

  * Changed PDO constants to class constants (PDO::CONST_NAME)
  * Changed SQLite extension to be a shared module in Windows distribution
  * Changed "instanceof" and "catch" operators, [is_a](http://php.net/is_a)() and [is_subclass_of](http://php.net/is_subclass_of)() functions to not call [__autoload](http://php.net/__autoload)()
  * Changed [sha1_file](http://php.net/sha1_file)() and [md5_file](http://php.net/md5_file)() functions to use streams instead of low level IO
  * Changed abstract private methods to be not allowed anymore
  * Changed [stream_filter_(ap|pre)pend](http://php.net/stream_filter_append)() to return resource
  * Changed mysqli_exception and sqlite_exception to use RuntimeException as base if SPL extension is present

###  Extensions moved to [PECL](http://pecl.php.net)

  * cpdf
  * dio
  * fam
  * ingres_ii
  * mcve
  * mnogosearch
  * oracle
  * ovrimos
  * pfpro
  * w32api
  * yp

###  Upgraded [PEAR](http://pear.php.net)

  * to channel-featuring v1.4###  Upgraded bundled libraries

### Upgraded bundled libraries

  * PCRE library to version 6.2
  * SQLite 3 library in ext/pdo_sqlite to 3.2.7
  * SQLite 2 library in ext/sqlite to 2.8.16###  Upgraded bundled libraries in Windows distribution

### Upgraded bundled libraries in Windows distribution
  * zlib 1.2.3
  * curl 7.14.0
  * openssl 0.9.8
  * ming 0.3b
  * libpq (PostgreSQL) 8.0.1

###  Improvements and Additions

  * Improved SPL extension  
    * Moved RecursiveArrayIterator from examples into extension
    * Moved RecursiveFilterIterator from examples into extension
    * Added SplObjectStorage
    * Made all SPL constants class constants
    * Renamed CachingRecursiveIterator to RecursiveCachingIterator to follow Recursive<*>Iterator naming scheme
  * Added support for class constants and static members for internal classes
  * Added PDO::MYSQL_ATTR_USE_BUFFERED_QUERY parameter for pdo_mysql
  * Added [date_timezone_set](http://php.net/date_timezone_set)() function to set the timezone that the date functions will use
  * Added [pg_fetch_all_columns](http://php.net/pg_fetch_all_columns)() function to fetch all values of a column from a result cursor
  * Added support for LOCK_EX flag for [file_put_contents](http://php.net/file_put_contents)()
  * Implemented feature request [#33452](http://bugs.php.net/33452)
  * Improved PHP extension loading mechanism with support for module dependencies and conflicts
  * Allowed return by reference from internal functions
  * Rewrote [strtotime](http://php.net/strtotime)() with support for timezones and many new formats. Implements feature requests [#21399](http://bugs.php.net/21399), [#26694](http://bugs.php.net/26694), [#28088](http://bugs.php.net/28088), [#29150](http://bugs.php.net/29150), [#29585](http://bugs.php.net/29585) and [#29595](http://bugs.php.net/29595)
  * Added bindto socket context option
  * Added offset parameter to the [stream_copy_to_stream](http://php.net/stream_copy_to_stream)() function
  * Added offset & length parameters to [substr_count](http://php.net/substr_count)() function
  * Removed [php_check_syntax](http://php.net/php_check_syntax)() function which never worked properly
  * Removed garbage manager in Zend Engine which results in more aggressive freeing of data
  * [Improved interactive mode of PHP CLI](http://blog.thinkphp.de/archives/44-More-PHP-power-on-the-command-line.html)
  * Improved performance of:
  * general execution/compilation
  * [switch](http://php.net/switch)() statement
  * several array functions
  * virtual path handling by adding a [realpath](http://php.net/realpath)() cache
  * variable fetches
  * magic method invocations
  * Improved support for embedded server in mysqli
  * Improved mysqli extension
  * added constructor for mysqli_stmt and mysqli_result classes
  * added new function [mysqli_get_charset](http://php.net/mysqli_get_charset)()
  * added new function [mysqli_set_charset](http://php.net/mysqli_set_charset)()
  * added new class mysqli_driver
  * added new class mysqli_warning
  * added new class mysqli_execption 
  * added new class mysqli_sql_exception
  * Improved SPL extension
  * added standard hierarchy of Exception classes
  * added interface Countable
  * added interfaces Subject and Observer
  * added spl_autoload*() functions
  * converted several 5.0 examples into c code
  * added class FileObject
  * added possibility to use a string with [class_parents](http://php.net/class_parents)() and [class_implements](http://php.net/class_implements)()
  * Added man pages for "phpize" and "php-config" scripts
  * Added support for .cc files in extensions
  * Added PHP_INT_MAX and PHP_INT_SIZE as predefined constants
  * Added user opcode API that allow overloading of opcode handlers
  * Added an optional remove old session parameter to [session_regenerate_id](http://php.net/session_regenerate_id)()
  * Added array type hinting
  * Added the [tidy_get_opt_doc](http://php.net/tidy_get_opt_doc)() function to return documentation for configuration options in tidy
  * Added support for .cc files in extensions
  * Added [imageconvolution](http://php.net/imageconvolution)() function which can be used to apply a custom 3x3 matrix convolution to an image
  * Added optional first parameter to XsltProcessor::registerPHPFunctions to only allow certain functions to be called from XSLT
  * Added the ability to override the autotools executables used by the buildconf script via the PHP_AUTOCONF and PHP_AUTOHEADER environmental variables
  * Added several new functions to support the PostgreSQL v3 protocol introduced in PostgreSQL 7.4
  * [pg_transaction_status](http://php.net/pg_transaction_status)() - in-transaction status of a database connection
  * [pg_query_params](http://php.net/pg_query_params)() - execution of parameterized queries
  * [pg_prepare](http://php.net/pg_prepare)() - prepare named queries
  * [pg_execute](http://php.net/pg_execute)() - execution of named prepared queries
  * [pg_send_query_params](http://php.net/pg_send_query_params)() - async equivalent of [pg_query_params](http://php.net/pg_query_params)()
  * [pg_send_prepare](http://php.net/pg_send_prepare)() - async equivalent of [pg_prepare](http://php.net/pg_prepare)()
  * [pg_send_execute](http://php.net/pg_send_execute)() - async equivalent of [pg_execute](http://php.net/pg_execute)()
  * [pg_result_error_field](http://php.net/pg_result_error_field)() - highly detailed error information, most importantly the SQLSTATE error code
  * [pg_set_error_verbosity](http://php.net/pg_set_error_verbosity)() - set verbosity of errors
  * Added optional fifth parameter "count" to [preg_replace_callback](http://php.net/preg_replace_callback)() and [preg_replace](http://php.net/preg_replace)() to count the number of replacements made. FR [#32275](http://bugs.php.net/32275)
  * Added optional third parameter "charlist" to [str_word_count](http://php.net/str_word_count)() which contains characters to be considered as word part. FR [#31560](http://bugs.php.net/31560)
  * Added interface Serializeable
  * Added [pg_field_type_oid](http://php.net/pg_field_type_oid)() PostgreSQL function
  * Added zend_declare_property_...() and zend_update_property_...() API functions for bool, double and binary safe strings
  * Added possibility to access INI variables from within .ini file
  * Added variable $_SERVER['REQUEST_TIME'] containing request start time
  * Added optional float parameter to [gettimeofday](http://php.net/gettimeofday)()
  * Added [apache_reset_timeout](http://php.net/apache_reset_timeout)() Apache1 function
  * Added [sqlite_fetch_column_types](http://php.net/sqlite_fetch_column_types)() 3rd argument for arrays
  * Added optional offset parameter to [stream_get_contents](http://php.net/stream_get_contents)() and [file_get_contents](http://php.net/file_get_contents)()
  * Added optional maxlen parameter to [file_get_contents](http://php.net/file_get_contents)()
  * Added SAPI hook to get the current request time
  * Added new functions:
  * [array_diff_key](http://php.net/array_diff_key)()
  * [array_diff_ukey](http://php.net/array_diff_ukey)()
  * [array_intersect_key](http://php.net/array_intersect_key)()
  * [array_intersect_ukey](http://php.net/array_intersect_ukey)()
  * [array_product](http://php.net/array_product)()
  * DomDocumentFragment::[appendXML](http://php.net/appendXML)()
  * [fputcsv](http://php.net/fputcsv)()
  * [htmlspecialchars_decode](http://php.net/htmlspecialchars_decode)()
  * [inet_pton](http://php.net/inet_pton)()
  * [inet_ntop](http://php.net/inet_ntop)()
  * mysqli::client_info property
  * [posix_access](http://php.net/posix_access)()
  * [posix_mknod](http://php.net/posix_mknod)()
  * SimpleXMLElement::XPathNamespace()
  * [stream_context_get_default](http://php.net/stream_context_get_default)()
  * [stream_socket_enable_crypto](http://php.net/stream_socket_enable_crypto)()
  * [stream_wrapper_unregister](http://php.net/stream_wrapper_unregister)()
  * [stream_wrapper_restore](http://php.net/stream_wrapper_restore)()
  * [stream_filter_remove](http://php.net/stream_filter_remove)()
  * [time_sleep_until](http://php.net/time_sleep_until)()
  * Added DomDocument::$recover property for parsing not well-formed XML Documents
  * Added Cursor support for MySQL 5.0.x in mysqli
  * Added proxy support to ftp wrapper via http
  * Added MDTM support to ftp_url_stat
  * Added zlib stream filter support
  * Added bz2 stream filter support
  * Added max_redirects context option that specifies how many HTTP redirects to follow
  * Added support of parameter=>value arrays to [xsl_xsltprocessor_set_parameter](http://php.net/xsl_xsltprocessor_set_parameter)()
