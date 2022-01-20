---
title: PHP commandline highlighter
author: m6w6
tags: 
- WTF 
- PHP
---

Just chewed up a command line highlighter for php code.  
It's hacky, but it fulfills my needs.

```php
class CHL {
	protected $colors = array(
		"start"		=> "0:0",
        "stop"		=> "0:0",
		"comment"	=> "33",
		"default"	=> "30",
		"html"		=> "32",
		"keyword"	=> "34",
		"string"	=> "31",
	);
	protected $encoding = "UTF-8";
    protected $tabstops;
    protected $colwidth;
	private $formats;
	
	public function __construct() {
		if ($files = $this->setup()) {
			foreach ($files as $file) {
				$this->highlight(file_get_contents($file), $file);
			}
		} elseif ($this->select()) {
			$this->highlight(file_get_contents("php://stdin"), "<STDIN>");
		} else {
			$this->usage();
		}
	}
	
	public function __destruct() {
		if ($this->tabstops) {
			echo "\033[3g";
			$this->tabstops = 8;
			$this->tabstops();
		}
	}
	
	protected function usage() {
		printf("Usage:\n");
		printf("\n");
		printf(" %s [-e ENC] [-t TAB] [-f FILE, ...] [-c TOKEN=COLOR, ...]\n", basename($_SERVER["argv"][0]));
		printf("\n");
		printf(" -e ENC              specify the character set of the highlighted code\n");
		printf(" -t TAB              specify the tab with\n");
		printf(" -f FILE             specify one or more files to highlight, STDIN if omitted\n");
		printf(" -c TOKEN=COLOR      specify the color code for the type of token\n");
		printf("    possible tokens: %s\n", implode(", ",array_keys($this->colors)));
		printf("\n");
		exit;
	}
	
	protected function setup() {
		$files = array();
		foreach (getopt("c:e:f:t:h") as $key => $val) {
			switch ($key) {
				case "h":
					$this->usage();
					break;
				case "c":
					foreach ((array)$val as $col) {
						list($type, $color) = explode("=", $col);
						$this->colors[$type] = $color;
					}
					break;
				case "e":
					$this->encoding = current(array_reverse((array)$val));
					break;
				case "t":
					if ($tabstops = (int) current(array_reverse((array)$val))) {
						$this->tabstops = $tabstops;
					}
					break;
				case "f":
					$files = (array) $val;
					break;
			}
        }

		if (!$this->colwidth = getenv("COLUMNS")) {
			if (preg_match("/columns (\d+)/", shell_exec("stty -a"), $m)) {
				$this->colwidth = $m[1];
			} else {
				$this->colwidth = 80;
			}
		}

		$this->tabstops && $this->tabstops();
		ini_set("highlight.comment", "comment");
		ini_set("highlight.default", "default");
		ini_set("highlight.html", "html");
		ini_set("highlight.keyword", "keyword");
		ini_set("highlight.string", "string");
		$this->formats = array(
			// get rid of html
			"/\R/"			=> "",
			"/<br \/>/"		=> "\n",
			"/<\/span>/"	=> "",
			"/(&nbsp;){4}/"	=> "\t",
			"/&nbsp;/"		=> " ",
			// convert colors
			"/<span style=\"color: comment\">/"	=> $this->color("comment"),
			"/<span style=\"color: default\">/"	=> $this->color("default"),
			"/<span style=\"color: html\">/"	=> $this->color("html"),
			"/<span style=\"color: keyword\">/"	=> $this->color("keyword"),
            "/<span style=\"color: string\">/"	=> $this->color("string"),
            // fix colors before newline
            #"/((\033\[\d+m)+)([[:punct:][:space:]]*)(\r?\n)/s" => "\$1\$3\$4\$1",
            // start/stop
			"/<code>/"		=> $this->color("start"),
			"/<\/code>/"	=> $this->color("stop", "", PHP_EOL),
		);
		return $files;
	}
	
	protected function select() {
		$r = $w = $e = array();
		$r[] = STDIN;
		if (stream_select($r, $w, $e, 0, 100) && $r[0]) {
			return true;
		}
		return false;
    }

    protected function tabstops() {
        $colw = $this->colwidth;
		$tabs = str_repeat(" ", $this->tabstops) . "\033H";
		$tabs = str_repeat($tabs, $colw/$this->tabstops);
		echo $tabs . "\r";
	}
	
	protected function color($type, $prepend = "", $append = "") {
		return $prepend . "\033[" . implode("m\033[", explode(":", $this->colors[$type])) . "m" . $append;
	}
	
	protected function highlight($code, $name) {
		echo "## Syntax highlighted code of $name:\n";
		echo html_entity_decode(
			preg_replace(
				array_keys($this->formats),
				array_values($this->formats),
				highlight_string($code, true)
			), 
			ENT_QUOTES, 
			$this->encoding
        );
        echo PHP_EOL;
	}
}
```

Cheers-

