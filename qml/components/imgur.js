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
function getAlbum(id, model, albumModel, onSuccess, onFailure) {
    var url = ENDPOINT_GALLERY_ALBUM;
    url += "/" + id;
    //console.log("getAlbum: " + url);

    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                handleAlbumJSON(xhr.responseText, model, albumModel);
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
                handleImageJSON(xhr.responseText, model, albumModel);
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
        var linkLarge = link;
        var id = "";

        if (output.is_album === false) {
            id = output.id;
        }
        else {
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
                            vote: vote
                         });
    }
}



/*
  Parse JSON for Gallery Album and fill models.
  https://api.imgur.com/models/gallery_album
*/
function handleAlbumJSON(response, model, albumModel) {
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
function handleImageJSON(response, model, albumModel) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));

    fillAlbumImagesModel(jsonObject.data, model);
    fillAlbumVariables(jsonObject.data, albumModel);
}

function fillAlbumImagesModel(output, model) {
    var title = "";
    if (output.title) {
        title = output.title;
    }
    var description = "";
    if (output.description) {
        description = output.description;
    }

    if (output.link) {
        if (parseInt(output.width) > 640) {
            var link = "http://i.imgur.com/";
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
        link: link
    };
    model.push(imageData);
}

function fillAlbumVariables(output, model) {
    if (output.account_url) {
        model.account_url = output.account_url;
    } else {
        model.account_url = "";
    }
    model.views = output.views;
    model.ups = output.ups;
    model.downs = output.downs;
    model.score = output.score;
    if (output.vote) {
        model.vote = output.vote;
    } else {
        model.vote = "";
    }
    if (output.favorite) {
        model.favorite = output.favorite;
    } else {
        model.favorite = false;
    }
    if (output.images_count) {
        model.images_count = output.images_count;
    } else {
        model.images_count = 0;
    }
    if(output.is_album) {
        model.is_album = output.is_album;
    } else {
        model.is_album = false;
    }

    var total = parseInt(model.ups) + parseInt(model.downs);
    model.upsPercent = Math.floor(100 * (model.ups/total));
    model.downsPercent = Math.ceil(100 * (model.downs/total));

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
    var date = new Date(output.datetime * 1000);
    var datetime = date.getHours() + ":" +
            date.getMinutes() + ":" +
            date.getSeconds() + ", " +
            date.getFullYear() + "-" + date.getMonth() + 1 + "-" + date.getDate();

    var childrens = parseInt(output.children.length);
    model.push({
                   id: output.id,
                   comment: replaceURLWithHTMLLinks(output.comment),
                   author: output.author,
                   ups: output.ups,
                   downs: output.downs,
                   points: output.points,
                   datetime: datetime,
                   children: output.children,
                   //childrens: childrens,
                   depth: depth
               });

    //console.log("childrens: " + JSON.stringify(output.children));

    if (childrens > 0) {
        depth += 1;
        for (var j=0; j < childrens; j++) {
            if (output.children[j].points > 1) {
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
    }
}
