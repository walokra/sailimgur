function getExt(link) {
    var ext = link.substr(link.lastIndexOf('.') + 1);
    return ext;
}

function replaceURLWithHTMLLinks(text) {
    if (text) {
        var exp = /(\b(https?):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
        return text.replace(exp,"<a href='$1'>$1</a>");
    }
    return text;
}

