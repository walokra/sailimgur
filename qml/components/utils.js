.pragma library

/**
  Parse image extension from string.
*/
function getExt(resource) {
    var ext = resource.substr(resource.lastIndexOf('.') + 1);
    return ext;
}

/**
  Replace all URLs (http://example.com) with href links (<a href="http://example.com">http://example.com</a>).
*/
function replaceURLWithHTMLLinks(text) {
    if (text) {
        var exp = /(\b(https?):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
        return text.replace(exp,"<a href='$1'>$1</a>");
    }
    return text;
}

