url_completion_use_bookmarks = true;
define_webjump("ddg", "http://duckduckgo.com/?q=%s");
define_webjump("pypi", "http://pypi.python.org/pypi?%3Aaction=search&term=%s&submit=search");

define_key(default_global_keymap, "C-c y", "bury-buffer");
