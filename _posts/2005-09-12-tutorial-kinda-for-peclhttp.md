---
title: Tutorial -kinda- for pecl/http
author: m6w6
tags:
- PHP
---

I've added a tiny tutorial, or sort of collection of usage examples,
to the pecl/http repository.

You can read it in the extended post, or just check it out from CVS.
Please note that the code for the XMLRPC client has just been put into CVS.

## GET Queries

The HttpRequest class can be used to execute any HTTP request method.
The following example shows a simple GET request where a few query
parameters are supplied. Additionally potential cookies will be read
from and written to a file.

```php
$r = new HttpRequest('http://www.google.com');

// store Googles cookies in a dedicated file
$r->setOptions(
    array(    'cookiestore'    => '../cookies/google.txt',
    )
);

$r->setQueryData(
    array(    'q'     => '+"pecl_http" -msg -cvs -list',
              'hl'    => 'de'
    )
);

// HttpRequest::send() returns an HttpMessage object
// of type HttpMessage::TYPE_RESPONSE or throws an exception
try {
    print $r->send()->getBody();
} catch (HttpException $e) {
    print $e;
}
```

## Multipart Posts


The following example shows an multipart POST request, with two form
fields and an image that's supposed to be uploaded to the server.

It's a bad habit as well as common practice to issue a redirect after
an received POST request, so we'll allow a redirect by enabling the
redirect option.

```php
$r = new HttpRequest('http://dev.iworks.at/.print_request.php',
    HTTP_METH_POST);

// if redirects is set to true, a single redirect is allowed;
// one can set any reasonable count of allowed redirects
$r->setOptions(
    array(    'cookies'    => array('MyCookie' => 'has a value'),
              'redirect'   => true,
    )
);

// common form data
$r->setPostFields(
    array(    'name'    => 'Mike',
              'mail'    => 'mike@php.net',
    )
);
// add the file to post (form name, file name, file type)
$r->addPostFile('image', 'profile.jpg', 'image/jpeg');

try {
    print $r->send()->getBody();
} catch (HttpException $e) {
    print $e;
}
```

## Parallel Requests

It's possible to execute several HttpRequests in parallel with the
HttpRequestPool class.  HttpRequests to send, do not need to perform
the same request method, but can only be attached to one HttpRequestPool
at the same time.

```php
try {
    $p = new HttpRequestPool;
    // if you want to set _any_ options of the HttpRequest object,
    // you need to do so *prior attaching* to the request pool!
    $p->attach(new HttpRequest('http://pear.php.net',
        HTTP_METH_HEAD));
    $p->attach(new HttpRequest('http://pecl.php.net',
        HTTP_METH_HEAD));
} catch (HttpException $e) {
    print $e;
    exit;
}

try {
    $p->send();
    // HttpRequestPool implements an iterator
    // over attached HttpRequest objects
    foreach ($p as $r) {
        echo "Checking ", $r->getUrl(), " reported ",
            $r->getResponseCode(), "\n";
    }
} catch (HttpException $e) {
    print $e;
}
```

### Parallel Requests?

You can use a more advanced approach by using the protected interface of
the HttpRequestPool class.  This allows you to perform some other tasks
while the requests are executed.

```php
class Pool extends HttpRequestPool
{
    public function __construct()
    {
        parent::__construct(
            new HttpRequest('http://pear.php.net',
                HTTP_METH_HEAD),
            new HttpRequest('http://pecl.php.net',
                HTTP_METH_HEAD)
        );

        // HttpRequestPool methods socketPerform() and
        // socketSelect() are protected;  one could use
        // this approach to do something else
        // while the requests are being executed
        print "Executing requests";
        for ($i = 0; $this->socketPerform(); $i++) {
            $i % 10 or print ".";
            if (!$this->socketSelect()) {
                throw new HttpException("Socket error!");
            }
        }
        print "nDone!n";
    }
}

try {
    foreach (new Pool as $r) {
        echo "Checking ", $r->getUrl(), " reported ",
            $r->getResponseCode(), "\n";
    }
} catch (HttpException $ex) {
    print $e;
}
```

## Cached Responses

One of the main key features of HttpResponse is HTTP caching.  HttpResponse
will calculate an ETag based on the http.etag_mode INI setting as well as
it will determine the last modification time of the sent entity.  It uses
those two indicators to decide if the cache entry on the client side is
still valid and will emit an &quot;304 Not Modified&quot; response if applicable.

```php
HttpResponse::setCacheControl('public');
HttpResponse::setCache(true);
HttpResponse::capture();

print "This will be cached until content changes!\n";
print "Note that this approach will only save the clients download time.\n";
```

## Bandwidth Throttling

HttpResponse supports a basic throttling mechanism, which is enabled by
setting a throttle delay and a buffer size.  PHP will sleep the specified
amount of seconds after each sent chunk of specified bytes.

```php
// send 5000 bytes every 0.2 seconds, i.e. max ~25kByte/s
HttpResponse::setThrottleDelay(0.2);
HttpResponse::setBufferSize(5000);
HttpResponse::setCache(true);
HttpResponse::setContentType('application/x-zip');
HttpResponse::setFile('../archive.zip');
HttpResponse::send();
```

## KISS XMLRPC Client

```php
class XmlRpcClient
{
    public $namespace;
    protected $request;

    public function __construct($url, $namespace = '')
    {
        $this->namespace = $namespace;
        $this->request = new HttpRequest($url, HTTP_METH_POST);
        $this->request->setContentType('text/xml');
    }

    public function setOptions($options = array())
    {
        return $this->request->setOptions($options);
    }

    public function addOptions($options)
    {
        return $this->request->addOptions($options);
    }

    public function __call($method, $params)
    {
        if ($this->namespace) {
            $method = $this->namespace .'.'. $method;
        }
        $this->request->setRawPostData(
            xmlrpc_encode_request($method, $params));
        $response = $this->request->send();
        if ($response->getResponseCode() != 200) {
            throw new Exception($response->getBody(),
                $response->getResponseCode());
        }
        return xmlrpc_decode($response->getBody(), 'utf-8');
    }

    public function getHistory()
    {
        return $this->request->getHistory();
    }
}
```

## Simple Feed Aggregator

```php
class FeedAggregator
{
    public $directory;
    protected $feeds = array();

    public function __construct($directory = 'feeds')
    {
        $this->setDirectory($directory);
    }

    public function setDirectory($directory)
    {
        $this->directory = $directory;
        foreach (glob($this->directory .'/*.xml') as $feed) {
            $this->feeds[basename($feed, '.xml')] = filemtime($feed);
        }
    }

    public function url2name($url)
    {
        return preg_replace('/[^w.-]+/', '_', $url);
    }

    public function hasFeed($url)
    {
        return isset($this->feeds[$this->url2name($url)]);
    }

    public function addFeed($url)
    {
        $r = $this->setupRequest($url);
        $r->send();
        $this->handleResponse($r);
    }

    public function addFeeds($urls)
    {
        $pool = new HttpRequestPool;
        foreach ($urls as $url) {
            $pool->attach($r = $this->setupRequest($url));
        }
        $pool->send();

        foreach ($pool as $request) {
            $this->handleResponse($request);
        }
    }

    public function getFeed($url)
    {
        $this->addFeed($url);
        return $this->loadFeed($this->url2name($url));
    }

    public function getFeeds($urls)
    {
        $feeds = array();
        $this->addFeeds($urls);
        foreach ($urls as $url) {
            $feeds[] = $this->loadFeed($this->url2name($url));
        }
        return $feeds;
    }

    protected function saveFeed($file, $contents)
    {
        if (file_put_contents($this->directory .'/'. $file .'.xml', $contents)) {
            $this->feeds[$file] = time();
        } else {
            throw new Exception(
                "Could not save feed contents to $file.xml");
        }
    }

    protected function loadFeed($file)
    {
        if (isset($this->feeds[$file])) {
            if ($data = file_get_contents($this->directory .'/'. $file .'.xml')) {
                return $data;
            } else {
                throw new Exception(
                    "Could not load feed contents from $file.xml");
            }
        } else {
            throw new Exception("Unknown feed/file $file.xml");
        }
    }

    protected function setupRequest($url)
    {
        $r = new HttpRequest($url);
        $r->setOptions(array('redirect' => true));

        $file = $this->url2name($url);

        if (isset($this->feeds[$file])) {
            $r->setOptions(array('lastmodified' => $this->feeds[$file]));
        }

        return $r;
    }

    protected function handleResponse(HttpRequest $r)
    {
        if ($r->getResponseCode() != 304) {
            if ($r->getResponseCode() != 200) {
                throw new Exception("Unexpected response code ".
                    $r->getResponseCode());
            }
            if (!strlen($body = $r->getResponseBody())) {
                throw new Exception("Received empty feed from ".
                    $r->getUrl());
            }
            $this->saveFeed($this->url2name($r->getUrl()), $body);
        }
    }
}
```
