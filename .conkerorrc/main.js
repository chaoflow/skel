require("clicks-in-new-buffer.js");

clicks_in_new_buffer_target = OPEN_NEW_BUFFER_BACKGROUND;
//cwd = "/home/cfl/incoming";
dowload_buffer_automatic_open_target = OPEN_NEW_BUFFER_BACKGROUND;
url_completion_use_bookmarks = true;
xkcd_add_title = true;

define_key(default_global_keymap, "C-c y", "bury-buffer");

// webjumps
define_webjump("ddg", "https://duckduckgo.com/?q=%s");
define_webjump("pypi", "http://pypi.python.org/pypi?%3Aaction=search&term=%s&submit=search");
read_url_handler_list = [read_url_make_default_webjump_handler("ddg")];
function possibly_valid_url(str) {
    return (/[\.\/:]/.test(str)) &&
        !(/\S\s+\S/.test(str)) &&
        !(/^\s*$/.test(str));
}


// only enable temporary to install extensions
//session_pref("xpinstall.whitelist.required", false);


// XXX: not working yet
session_pref("signon.rememberSignons", true);
session_pref("signon.expireMasterPassword", false);
Cc["@mozilla.org/login-manager;1"].getService(Ci.nsILoginManager); // init



// XXX: not working yet
// http://tsdh.wordpress.com/2008/11/14/calling-org-remember-from-inside-conkeror/
function org_remember(url, title, text, window) {
    var eurl = encodeURIComponent(url);
    var etitle = encodeURIComponent(title);
    var etext = encodeURIComponent(text);
    var cmd_str = "emacsclient -c org-protocol://remember://" + eurl + "/" + etitle + "/" + etext;
    window.minibuffer.message("Issuing " + cmd_str);
    shell_command_blind(cmd_str);
}

interactive(
    "org-remember", "Remember the current url with org-remember",
    function (I) {
        org_remember(I.buffer.display_uri_string,
                     I.buffer.document.title,
                     I.buffer.top_frame.getSelection(),
                     I.window);
    }
);
