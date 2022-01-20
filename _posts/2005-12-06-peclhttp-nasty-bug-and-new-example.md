---
title: PECL::HTTP - A nasty bug and a new example
author: m6w6
tags: 
- PHP
---

I just fixed a nasty bug which caused GZIP encoded files (speak tgz etc.) to
be decoded. While it'll just eat **some** memory on a 200 response (besides
that the body is not what one would expect), it'll eat all memory on 206
(partial content) responses because the part is fed through zlib. I'll just
need to revisit the HTTP RFC to check if checking for the "Vary" response
header is the best bet before I drop the new release.

Ok, that's it about the bad news -- I also added a new example to the tutorial
which shows how one could efficiently download big files. Using the example
code would look like:

```php  
$bigget = BigGet::url('http://example.com/big_file.bin');  
$bigGet->saveTo('big_file.bin');  

class BigGetRequest extends HttpRequest  
{  
    public $id;  
}  
  
class BigGet extends HttpRequestPool  
{  
    const SIZE = 1048576;  
  
    private $url;  
    private $size;  
    private $count = 0;  
    private $files = array();  
  
    static function url($url)  
    {  
        $head = new HttpRequest($url, HttpRequest::METH_HEAD);  
        $headers = $head->send()->getHeaders();  
        $head = null;  
  
        if (!isset($headers['Accept-Ranges'])) {  
            throw new HttpExcpetion("Did not receive an ".  
                "Accept-Ranges header from HEAD $url");  
        }  
        if (!isset($headers['Content-Length'])) {  
            throw new HttpException("Did not receive a ".  
                "Content-Length header from HEAD $url");  
        }  
  
        $bigget = new Bigget;  
        $bigget->url = $url;  
        $bigget->size = $headers['Content-Length'];  
        return $bigget;  
    }  
  
    function saveTo($file)  
    {  
        $this->send();  
        if ($w = fopen($file, 'wb')) {  
            echo "nCopying temp files to $file ...n";  
            foreach (glob("bigget_????.tmp") as $tmp) {  
                echo "t$tmpn";  
                if ($r = fopen($tmp, 'rb')) {  
                    stream_copy_to_stream($r, $w);  
                    fclose($r);  
                }  
                unlink($tmp);  
            }  
            fclose($w);  
            echo "nDone.n";  
        }  
    }  
  
    function send()  
    {  
        // use max 3 simultanous requests with a req size of 1MiB  
        while ($this->count < 3 &&  
                -1 != $offset = $this->getRangeOffset()) {  
            $this->attachNew($offset);  
        }  
  
        while ($this->socketPerform()) {  
            if (!$this->socketSelect()) {  
                throw new HttpSocketException;  
            }  
        }  
    }  
  
    private function attachNew($offset)  
    {  
        $stop = min($this->count * self::SIZE + self::SIZE,  
            $this->size) - 1;  
  
        echo "Attaching new request to get range: $offset-$stopn";  
  
        $req = new BigGetRequest(  
            $this->url,  
            HttpRequest::METH_GET,  
            array(  
                'headers' => array(  
                    'Range' => "bytes=$offset-$stop"  
                )  
            )  
        );  
        $this->attach($req);  
        $req->id = $this->count++;  
    }  
  
    private function getRangeOffset()  
    {  
        return ($this->size >=  
            $start = $this->count * self::SIZE) ? $start : -1;  
    }  
  
    protected function socketPerform()  
    {  
        try {  
            $rc = parent::socketPerform();  
        } catch (HttpRequestPoolException $x) {  
            foreach ($x->exceptionStack as $e) {  
                echo $e->getMessage(), "n";  
            }  
        }  
  
        foreach ($this->getFinishedRequests() as $r) {  
            $this->detach($r);  
  
            if (206 != $rc = $r->getResponseCode()) {  
                throw new HttpException(  
                    "Unexpected response code: $rc");  
            }  
  
            file_put_contents(  
                sprintf("bigget_%04d.tmp", $r->id),  
                $r->getResponseBody());  
  
            if (-1 != $offset = $this->getRangeOffset()) {  
                $this->attachNew($offset);  
            }  
        }  
  
        return $rc;  
    }  
}
```
