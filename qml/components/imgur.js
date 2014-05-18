.pragma library

Qt.include("utils.js");

// OAUTH
var AUTHORIZE_URL = "https://api.imgur.com/oauth2/authorize"
var ACCESS_TOKEN_URL = "https://api.imgur.com/oauth2/token"
var OAUTH_CONSUMER_KEY;
var OAUTH_CONSUMER_SECRET;
var OAUTH_ACCESS_TOKEN;
var OAUTH_REFRESH_TOKEN;
var USER_AGENT;

// ENDPOINTS
var BASEURL = "https://api.imgur.com/3";

// https://api.imgur.com/3/gallery/{section}/{sort}/{page}?showViral=bool
var ENDPOINT_GALLERY = BASEURL + "/gallery";
// https://api.imgur.com/3/gallery/random/random/{page}
var ENDPOINT_GET_GALLERY_RANDOM = ENDPOINT_GALLERY + "/random/random";
// https://api.imgur.com/3/gallery/g/memes/{sort}/{window}/{page}
var ENDPOINT_GET_GALLERY_MEMES = ENDPOINT_GALLERY + "/g/memes";
var ENDPOINT_GET_CREDITS = BASEURL + "/credits";
// https://api.imgur.com/3/gallery/search/{sort}/{page}?q=string
var ENDPOINT_GALLERY_SEARCH = ENDPOINT_GALLERY + "/search";

var ENDPOINT_GALLERY_ALBUM = ENDPOINT_GALLERY + "/album";
var ENDPOINT_GALLERY_IMAGE = ENDPOINT_GALLERY + "/image"
var ENDPOINT_ALBUM = BASEURL + "/album/";
var ENDPOINT_IMAGE = BASEURL + "/image/";

// needs sign in
var ENDPOINT_ACCOUNT = BASEURL + "/account";
var ENDPOINT_ACCOUNT_CURRENT = ENDPOINT_ACCOUNT + "/me";
var ENDPOINT_ACCOUNT_CURRENT_IMAGES = ENDPOINT_ACCOUNT_CURRENT + "/me/images";

function init(client_id, client_secret, access_token, refresh_token, user_agent) {
    OAUTH_CONSUMER_KEY = client_id;
    OAUTH_CONSUMER_SECRET = client_secret;
    OAUTH_ACCESS_TOKEN = access_token;
    OAUTH_REFRESH_TOKEN = refresh_token;
    USER_AGENT = user_agent;
}

function exchangePinForAccessToken(pin, onSuccess, onFailure) {
    var message = "client_id=" + OAUTH_CONSUMER_KEY + "&client_secret=" + OAUTH_CONSUMER_SECRET + "&grant_type=pin&pin=" + pin;
    //console.log("message=" + message);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', ACCESS_TOKEN_URL);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            //console.log("headers: " + xhr.getAllResponseHeaders());
            var jsonObject = JSON.parse(xhr.responseText);
            if (xhr.status == 200) {
                //console.log("response: " + JSON.stringify(jsonObject));
                OAUTH_ACCESS_TOKEN = jsonObject.access_token;
                OAUTH_REFRESH_TOKEN = jsonObject.refresh_token;
                onSuccess(OAUTH_ACCESS_TOKEN, OAUTH_REFRESH_TOKEN);
            } else {
                //console.log("exchangePinForAccessToken", xhr.status, xhr.statusText, xhr.responseText);
                onFailure(xhr.status, xhr.statusText + ": " +jsonObject.data.error);
            }
        }
    }

    xhr = createPOSTHeader(xhr, message);
    xhr.send(message);
}

function refreshAccessToken(refresh_token, onSuccess, onFailure) {
    var message = "client_id=" + OAUTH_CONSUMER_KEY + "&client_secret=" + OAUTH_CONSUMER_SECRET + "&grant_type=refresh_token&refresh_token=" + refresh_token;
    //console.log("message=" + message);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', ACCESS_TOKEN_URL);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            //console.log("headers: " + xhr.getAllResponseHeaders());
            var jsonObject = JSON.parse(xhr.responseText);
            if (xhr.status == 200) {
                //console.log("response: " + JSON.stringify(jsonObject));
                var tokenType = jsonObject.token_type;
                if (tokenType === "bearer") {
                    OAUTH_ACCESS_TOKEN = jsonObject.access_token;
                    OAUTH_REFRESH_TOKEN = jsonObject.refresh_token;
                    onSuccess(OAUTH_ACCESS_TOKEN, OAUTH_REFRESH_TOKEN);
                } else {
                    onFailure(xhr.status, "Wrong token type.");
                }
            } else {
                //console.log(xhr.status, xhr.statusText, xhr.responseText);
                onFailure(xhr.status, xhr.statusText + ": " + jsonObject.data.error);
            }
        }
    }

    xhr = createPOSTHeader(xhr, message);
    xhr.send(message);
}

/**
  Get current user info.

Account Base
Request standard user information. If you need the username for the account that is logged in,
it is returned in the request for an access token.
Method	GET
Route	https://api.imgur.com/3/account/{username}
Response Model	Account
*/
function getAccountCurrent(onSuccess, onFailure) {
    var url = ENDPOINT_ACCOUNT_CURRENT;

    var xhr = new XMLHttpRequest();
    xhr.open('GET', url);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            //console.log("headers: " + xhr.getAllResponseHeaders());
            // permission denied, check if token expired and try to refresh it
            if (xhr.status == 403) {
                onFailure(xhr.status, xhr.statusText);
            } else if (xhr.status == 200) {
                var jsonObject = JSON.parse(xhr.responseText);
                //console.log("response: " + JSON.stringify(jsonObject));
                onSuccess(jsonObject.data.url);
            } else {
                //console.log(xhr.status, xhr.statusText, xhr.responseText);
                onFailure(xhr.status, xhr.statusText);
            }
        }
    }

    xhr = createGETHeader(xhr);
    xhr.send();
}

/**
  Get current user's favorited images.

Account Favorites
Returns the users favorited images, only accessible if you're logged in as the user.
Method	GET
Route	https://api.imgur.com/3/account/{username}/favorites
Response Model	Gallery Image OR Gallery Album
*/
function getFavorites(model, onSuccess, onFailure) {
    var url = ENDPOINT_ACCOUNT_CURRENT;
    url += "/favorites";

    sendJSONRequest(url, 1, model, onSuccess, onFailure);
}

/*
Account Settings
Returns the account settings, only accessible if you're logged in as the user.
Method	GET
Route	https://api.imgur.com/3/account/{username}/settings
Response Model	Account Settings
*/

/*
Albums
Get all the albums associated with the account. Must be logged in as the user to see secret and hidden albums.
Method	GET
Route	https://api.imgur.com/3/account/{username}/albums/{page}
Response Model	Album
Parameters
Key	Required	Description
page	optional	integer - allows you to set the page number so you don't have to retrieve all the data at once.
*/
function getAlbums(model, page, onSuccess, onFailure) {
    var url = ENDPOINT_ACCOUNT_CURRENT;
    url += "/albums";
    url += "/" + page;

    sendJSONRequest(url, "albums", model, onSuccess, onFailure);
}

/*
Images
Return all of the images associated with the account. You can page through the images by setting the page, this defaults to 0.
Method	GET
Route	https://api.imgur.com/3/account/{username}/images/{page}
Response Model	Image
*/
function getImages(model, page, onSuccess, onFailure) {
    var url = ENDPOINT_ACCOUNT_CURRENT;
    url += "/images";
    url += "/" + page;

    sendJSONRequest(url, "images", model, onSuccess, onFailure);
}

/*
Gallery
Returns the images in the gallery. For example the main gallery is https://api.imgur.com/3/gallery/hot/viral/0.json

https://api.imgur.com/3/gallery/{section}/{sort}/{window}/{page}?showViral=bool

section 	optional 	hot | top | user - defaults to hot
sort 	optional 	viral | time - defaults to viral
page 	optional 	integer - the data paging number
window 	optional 	Change the date range of the request if the section is "top", day | week | month | year | all, defaults to day
showViral 	optional 	true | false - Show or hide viral images from the 'user' section. Defaults to true
*/
function getGallery(model, page, settings, onSuccess, onFailure) {
    var url = ENDPOINT_GALLERY;
    url += "/" + settings.section + "/" + settings.sort + "/" + settings.window + "/" + page + "/?showViral=" + settings.showViral;
    //console.log("getGallery: " + url);
    sendJSONRequest(url, 1, model, onSuccess, onFailure);
}

/*
Random Gallery Images
Returns a random set of gallery images.

https://api.imgur.com/3/gallery/random/random/{page}

page 	optional 	A page of random gallery images, from 0-50. Pages are regenerated every hour.
*/
function getRandomGalleryImages(model, page, onSuccess, onFailure) {
    var url = ENDPOINT_GET_GALLERY_RANDOM;
    url += "/" + page;

    sendJSONRequest(url, 1, model, onSuccess, onFailure);
}

/**
Memes Subgallery
View images for memes subgallery

Route	https://api.imgur.com/3/gallery/g/memes/{sort}/{page}
https://api.imgur.com/3/gallery/g/memes/{sort}/{window}/{page}

sort	optional	viral | time | top - defaults to viral
page	optional	integer - the data paging number
window	optional	Change the date range of the request if the sort is "top", day | week | month | year | all, defaults to week
*/
function getMemesSubGallery(model, page, settings, onSuccess, onFailure) {
    var url = ENDPOINT_GET_GALLERY_MEMES;
    url += "/" + settings.sort + "/" + settings.window + "/" + page;
    url += "/" + page;

    sendJSONRequest(url, 1, model, onSuccess, onFailure);
}

function sendJSONRequest(url, actiontype, model, onSuccess, onFailure) {
    //console.log("sendJSONRequest, url=" + url + ", actiontype=" + actiontype);
    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                //console.log("ok, actiontype=" + actiontype);
                if (actiontype === 1) {
                    handleGalleryJSON(xhr.responseText, model);
                } else if (actiontype === 4) {
                    handleCommentsJSON(xhr.responseText, model);
                } else if (actiontype === "albums") {
                    handleAlbumsJSON(xhr.responseText, model);
                } else if (actiontype === "images") {
                    handleImagesJSON(xhr.responseText, model);
                }
                //console.log("RateLimit: user=" + creditsUserRemaining  + ", client=" + creditsClientRemaining);
                onSuccess(xhr.status);
            } else {
                //console.log("error: " + xhr.status+"; "+ xhr.responseText);
                var jsonObject = JSON.parse(xhr.responseText);
                onFailure(xhr.status, xhr.statusText + ": " + jsonObject.data.error);
            }
        }
    }

    xhr = createGETHeader(xhr);
    xhr.send();
}

/*
Gallery Search
Search the gallery with a given query string.

https://api.imgur.com/3/gallery/search/{sort}/{page}?q=string

q       required 	Query string
sort 	optional 	time | viral - defaults to time
page 	optional 	integer - the data paging number
*/
function getGallerySearch(query, model, page, settings, onSuccess, onFailure) {
    var url = ENDPOINT_GALLERY_SEARCH;
    url += "/" + settings.sort + "/" + page + "/?q=" + query;
    //console.log("getGallerySearch: " + url);

    sendJSONRequest(url, 1, model, onSuccess, onFailure);
}

// get gallery album
function getGalleryAlbum(id, model, albumModel, onSuccess, onFailure) {
    var url = ENDPOINT_GALLERY_ALBUM;
    url += "/" + id;
    //console.log("getGalleryAlbum: " + url);

    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                handleGalleryAlbumJSON(xhr.responseText, model, albumModel);
                //console.log("RateLimit: user=" + creditsUserRemaining  + ", client=" + creditsClientRemaining);
                onSuccess(xhr.status);
            } else {
                //console.log("error: " + xhr.status+"; "+ xhr.responseText);
                var jsonObject = JSON.parse(xhr.responseText);
                onFailure(xhr.status, xhr.statusText + ": " + jsonObject.data.error);
            }
        }
    }

    xhr = createGETHeader(xhr);
    xhr.send();
}

// get album
function getAlbum(id, model, albumModel, onSuccess, onFailure) {
    var url = ENDPOINT_ALBUM;
    url += "/" + id;
    //console.log("getAlbum: " + url);

    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                handleGalleryAlbumJSON(xhr.responseText, model, albumModel);
                //console.log("RateLimit: user=" + creditsUserRemaining  + ", client=" + creditsClientRemaining);
                onSuccess(xhr.status);
            } else {
                //console.log("error: " + xhr.status+"; "+ xhr.responseText);
                var jsonObject = JSON.parse(xhr.responseText);
                onFailure(xhr.status, xhr.statusText + ": " + jsonObject.data.error);
            }
        }
    }

    xhr = createGETHeader(xhr);
    xhr.send();
}

// get gallery image
function getGalleryImage(id, model, albumModel, onSuccess, onFailure) {
    var url = ENDPOINT_GALLERY_IMAGE;
    url += "/" + id;
    //console.log("getGalleryImage: " + url);

    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                handleGalleryImageJSON(xhr.responseText, model, albumModel);
                onSuccess(xhr.status);
            } else {
                var jsonObject = JSON.parse(xhr.responseText);
                onFailure(xhr.status, xhr.statusText + ": " + jsonObject.data.error);
            }
        }
    }
    xhr = createGETHeader(xhr);
    xhr.send();
}

// get image
function getImage(id, model, albumModel, onSuccess, onFailure) {
    var url = ENDPOINT_IMAGE;
    url += "/" + id;
    //console.log("getImage: " + url);

    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                handleGalleryImageJSON(xhr.responseText, model, albumModel);
                onSuccess(xhr.status);
            } else {
                var jsonObject = JSON.parse(xhr.responseText);
                onFailure(xhr.status, xhr.statusText + ": " + jsonObject.data.error);
            }
        }
    }
    xhr = createGETHeader(xhr);
    xhr.send();
}

/*
Album/Image Comments
Comment on an image in the gallery.

https://api.imgur.com/endpoints/gallery#gallery-comments

Route	https://api.imgur.com/3/gallery/album/{id}/comments/{sort}
Route	https://api.imgur.com/3/gallery/image/{id}/comments/{sort}
Route	https://api.imgur.com/3/gallery/{id}/comments/{sort}

sort	optional	best | top | new - defaults to best
*/
function getGalleryComments(id, model, onSuccess, onFailure) {
    var url = ENDPOINT_GALLERY;
    url += "/" + id + "/comments";
    //console.log("getGalleryComments: " + url);

    sendJSONRequest(url, 4, model, onSuccess, onFailure);
}

/**
  Check the current rate limit status
*/
function getCredits(onSuccess, onFailure) {
    var url = ENDPOINT_GET_CREDITS;

    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            var jsonObject = JSON.parse(xhr.responseText);
            if (xhr.status == 200) {
                var data = jsonObject.data;
                onSuccess(data.UserRemaining, data.ClientRemaining);
            } else {
                //console.log("error: " + xhr.status+"; "+ xhr.responseText);
                onFailure(xhr.status, xhr.statusText + ": " + jsonObject.data.error);
            }
        }
    }

    xhr = createGETHeader(xhr);
    xhr.send();
}

/*
    Parse JSON for main Gallery (main, search, random) and fill galleryModel.
*/
function handleGalleryJSON(response, model) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));

    for (var i in jsonObject.data) {
        var output = jsonObject.data[i];
        var ext = 'jpg';
        var link = "http://i.imgur.com/";
        var linkLarge = output.link;
        var id = "";

        if (output.is_album === false) {
            id = output.id;
        } else {
            id = output.cover;
            //console.log("album cover=" + id);
        }

        link += id+"b."+ext; // s=90x90, b=160x160, t=160x160 (aspect)
        //console.log("link=" + link);

        var title = "";
        if (output.title) {
            title = output.title;
        }
        var vote = "";
        if (output.vote) {
            vote = output.vote;
        }

        model.append({
                         id: output.id,
                         title: title,
                         link: link,
                         is_album: output.is_album,
                         vote: vote,
                         is_gallery: true
                     });
    }
}

/*
    Parse JSON for Albums.
*/
function handleAlbumsJSON(response, model) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));

    //console.log("response: " + JSON.stringify(jsonObject.data));
    for (var i in jsonObject.data) {
        var output = jsonObject.data[i];
        var ext = 'jpg';
        var link = "http://i.imgur.com/";
        var linkLarge = output.link;
        var id = output.cover;

        link += id+"b."+ext; // s=90x90, b=160x160, t=160x160 (aspect)

        var title = "";
        if (output.title) {
            title = output.title;
        }

        model.append({
                         id: output.id,
                         title: title,
                         link: link,
                         is_album: true,
                         vote: "",
                         is_gallery: false
                     });
    }
}

/*
    Parse JSON for Images.
*/
function handleImagesJSON(response, model) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));

    //console.log("response: " + JSON.stringify(jsonObject.data));
    for (var i in jsonObject.data) {
        var output = jsonObject.data[i];
        var ext = 'jpg';
        var link = "http://i.imgur.com/";
        var linkLarge = output.link;
        var id = output.id;

        link += id+"b."+ext; // s=90x90, b=160x160, t=160x160 (aspect)

        var title = "";
        if (output.title) {
            title = output.title;
        }

        model.append({
                         id: output.id,
                         title: title,
                         link: link,
                         is_album: false,
                         vote: "",
                         is_gallery: false
                     });
    }
}

/*
  Parse JSON for Gallery Album and fill models.
  https://api.imgur.com/models/gallery_album
*/
function handleGalleryAlbumJSON(response, model, albumModel) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));

    var data = jsonObject.data;
    //console.log("data.is_album=" + data.is_album + "; data.images_count=" + data.images_count);
    for (var i in jsonObject.data.images) {
        //console.log("image[" + i + "]=" + JSON.stringify(jsonObject.data.images[i]));
        //console.log("output=" + JSON.stringify(output));
        fillAlbumImagesModel(jsonObject.data.images[i], model);
    }
    //console.log("count=" + model.count);

    fillAlbumVariables(data, albumModel);
}

/*
  Parse JSON for Image and fill albumModel.
  https://api.imgur.com/models/gallery_image
*/
function handleGalleryImageJSON(response, model, albumModel) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));

    fillAlbumImagesModel(jsonObject.data, model);
    fillAlbumVariables(jsonObject.data, albumModel);
}

function fillAlbumImagesModel(output, model) {
    var title = setVariable(output.title);
    var description = setVariable(output.description);
    var link;
    var link_original;

    if (output.link) {
        link = "http://i.imgur.com/";
        link_original = output.link;
        if (parseInt(output.width) > 640) {
            // if image isn't gif then get the smaller one
            var ext = getExt(output.link);
            if (ext === "gif" || ext === "GIF") {
                link = output.link;
            } else {
                link += output.id+"l."+ext; // l=640x640 aspec
            }
        } else {
            link = output.link;
        }

    }

    var imageData = {
        id: output.id,
        title: title,
        description: replaceURLWithHTMLLinks(description),
        datetime: output.datetime,
        animated: output.animated,
        width: output.width,
        height: output.height,
        size: output.size,
        views: output.views,
        bandwidth: output.bandwidth,
        link: link,
        link_original: link_original
    };
    model.push(imageData);
}

function fillAlbumVariables(output, model) {
    model.title = setVariable(output.title);
    model.description = setVariable(output.description);
    model.datetime = (output.datetime) ? formatEpochDatetime(output.datetime) : "";
    model.link = setVariable(output.link);
    model.account_url = setVariable(output.account_url);
    model.views = output.views;
    model.deletehash = setVariable(output.deletehash);

    model.ups = (output.ups) ? output.ups : 0;
    model.downs = (output.downs) ? output.downs : 0;
    model.score = (output.score) ? output.score : 0;

    model.vote = setVariable(output.vote);
    model.favorite = (output.favorite) ? output.favorite : false;
    model.images_count = (output.images_count) ? output.images_count : 0;
    model.is_album = (output.is_album) ? output.is_album : false;
    if (output.is_album) {
        model.gallery_page_link = "http://imgur.com/a/" + output.id;
    } else {
        model.gallery_page_link = "http://imgur.com/" + output.id;
    }

    var total = 0;
    if (model.ups && model.downs) {
        total = parseInt(model.ups) + parseInt(model.downs);
        model.upsPercent = Math.floor(100 * (model.ups/total));
        model.downsPercent = Math.ceil(100 * (model.downs/total));
    } else {
        model.upsPercent = 0;
        model.downsPercent = 0;
    }

    //console.log("score=" + score + "; total=" + total + "; ups=" + ups + "; downs=" + downs + " upsPercent=" + upsPercent + "; downsPercent="  + downsPercent);
}

function handleCommentsJSON(response, model) {
    var jsonObject = JSON.parse(response);
    //console.log("handleCommentsJSON()");
    //console.log("comments: " + JSON.stringify(jsonObject));

    for (var i in jsonObject.data) {
        var output = jsonObject.data[i];
        parseComments(output, 0, model);
    }

    //console.log("comments=" + model.count);
}

function parseComments(output, depth, model) {
    var date = formatEpochDatetime(output.datetime);

    var childrens = parseInt(output.children.length);
    model.push({
                   id: output.id,
                   comment: replaceURLWithHTMLLinks(output.comment),
                   author: output.author,
                   ups: output.ups,
                   downs: output.downs,
                   points: output.points,
                   datetime: date,
                   children: output.children,
                   //childrens: childrens,
                   depth: depth
               });

    //console.log("childrens: " + JSON.stringify(output.children));

    if (childrens > 0) {
        depth += 1;
        for (var j=0; j < childrens; j++) {
            var points = parseInt(output.children[j].points);
            if ( points > 0) {
                parseComments(output.children[j], depth, model);
            }
        }
    }
}

/**
    Favorite an album with a given ID. The user is required to be logged in to favorite the album.
    Method	POST
    Route	https://api.imgur.com/3/album/{id}/favorite
    Response Model	Basic
*/
function albumFavorite(id, onSuccess, onFailure) {
    var url = ENDPOINT_ALBUM + "/" + id + "/favorite";
    sendJSONPOSTRequest(url, onSuccess, onFailure);
}

/**
    Favorite an image with the given ID. The user is required to be logged in to favorite the image.
    Method	POST
    Route	https://api.imgur.com/3/image/{id}/favorite
    Response Model	Basic
*/
function imageFavorite(id, onSuccess, onFailure) {
    var url = ENDPOINT_IMAGE+ "/" + id + "/favorite";
    sendJSONPOSTRequest(url, onSuccess, onFailure);
}

/**
    Album/Image Voting
    Vote for an image, 'up' or 'down' vote. Send the same value again to undo a vote.
    Method	POST
    Route	https://api.imgur.com/3/gallery/album/{id}/vote/{vote}
    Route	https://api.imgur.com/3/gallery/image/{id}/vote/{vote}
    Route	https://api.imgur.com/3/gallery/{id}/vote/{vote}
    Response Model	Basic
*/
function galleryVote(id, vote, onSuccess, onFailure) {
    var url = ENDPOINT_GALLERY + "/" + id + "/vote/" + vote;
    sendJSONPOSTRequest(url, onSuccess, onFailure);
}

function sendJSONPOSTRequest(url, onSuccess, onFailure) {
    var xhr = new XMLHttpRequest();

    xhr.open("POST", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                var jsonObject = JSON.parse(xhr.responseText);
                //console.log("output=" + JSON.stringify(jsonObject));
                onSuccess(jsonObject.data);
            } else {
                //console.log("error: " + xhr.status+"; "+xhr.responseText);
                onFailure(xhr.status, xhr.responseText);
            }
        }
    }

    // Send the proper header information along with the request
   if (OAUTH_ACCESS_TOKEN === "") {
       onFailure(xhr.status, "You need to be signed in for this action.");
    } else {
       xhr.setRequestHeader("Authorization", "Bearer " + OAUTH_ACCESS_TOKEN);
    }

    xhr.send();
}

function createPOSTHeader(xhr, message) {
    // Send the proper header information along with the request
    xhr.setRequestHeader("Authorization", "Client-ID " + OAUTH_CONSUMER_KEY);
    xhr.setRequestHeader("Content-length", message.length);
    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhr.setRequestHeader("User-Agent", USER_AGENT);
    return xhr;
}

function createGETHeader(xhr) {
    //console.log("OAUTH_CONSUMER_KEY=" + OAUTH_CONSUMER_KEY + "; OAUTH_ACCESS_TOKEN=" + OAUTH_ACCESS_TOKEN);
    if (OAUTH_ACCESS_TOKEN === "") {
        xhr.setRequestHeader("Authorization", "Client-ID " + OAUTH_CONSUMER_KEY);
    } else {
        xhr.setRequestHeader("Authorization", "Bearer " + OAUTH_ACCESS_TOKEN);
    }

    xhr.setRequestHeader("User-Agent", USER_AGENT);
    return xhr;
}

function processGalleryMode(query, model, page, settings, onSuccess, onFailure) {
    if (query) {
        getGallerySearch(query, model, page, settings, onSuccess, onFailure);
    }
    else if (settings.mode === "main" || settings.mode === "user" || settings.mode === "score") {
        getGallery(model, page, settings, onSuccess, onFailure);
    } else if (settings.mode === "random") {
        getRandomGalleryImages(model, page, onSuccess, onFailure);
    } else if (settings.mode === "memes") {
        getMemesSubGallery(model, page, settings, onSuccess, onFailure);
    } else if (settings.mode === "favorites") {
        getFavorites(model, onSuccess, onFailure);
    } else if (settings.mode === "albums") {
        getAlbums(model, page, onSuccess, onFailure);
    } else if (settings.mode === "images") {
        getImages(model, page, onSuccess, onFailure);
    }
}

/**
Image Upload
Upload a new image.
Method	POST
Route	https://api.imgur.com/3/image
Alternative Route	https://api.imgur.com/3/upload
Response Model	Basic

Parameters
Key	Required	Description
image	required	A binary file, base64 data, or a URL for an image
album	optional    The id of the album you want to add the image to. For anonymous albums, {album} should be the deletehash that is returned at creation.
type	optional	The type of the file that's being sent; file, base64 or URL
name	optional	The name of the file, this is automatically detected if uploading a file with a POST and multipart / form-data
title	optional	The title of the image.
description	optional	The description of the image.
*/
function uploadImage(imagePath, album, name, title, desc, onSuccess, onFailure) {

    /*
    var reader = new FileReader();
    reader.onload = function(evt) {
        var fileData = evt.target.result;
        console.log("File contents: " + fileData);
    };
    reader.onerror = function(event) {
        console.error("File could not be read! Code " + event.target.error.code);
    };
    var message = "image=" + reader.readAsDataURL(imagePath);
    */

    if (album) {
        message += "&album=" + album;
    }
    if (name) {
        message += "&name=" + name;
    }
    message += "&type=base64";
    if (title) {
        message += "&title=" + title;
    }
    if (desc) {
        message += "&description=" + desc;
    }

    //console.log("message=" + message);

    /*
    var xhr = new XMLHttpRequest();
    xhr.open('POST', ENDPOINT_IMAGE);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            //console.log("headers: " + xhr.getAllResponseHeaders());
            var jsonObject = JSON.parse(xhr.responseText);
            if (xhr.status == 200) {
                console.log("response: " + JSON.stringify(jsonObject));
                onSuccess();
            } else {
                //console.log(xhr.status, xhr.statusText, xhr.responseText);
                onFailure(xhr.status, xhr.statusText + ": " + jsonObject.data.error);
            }
        }
    }

    xhr = createPOSTHeader(xhr, message);
    //xhr.send(message);
    */
}
