.pragma library

Qt.include("imgur_oauth.js");
Qt.include("utils.js");

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

// Reddit stuff
var redditModeActive = false; // Global

var ENDPOINT_GALLERY_ALBUM = ENDPOINT_GALLERY + "/album";
var ENDPOINT_GALLERY_IMAGE = ENDPOINT_GALLERY + "/image"
var ENDPOINT_ALBUM = BASEURL + "/album/";
var ENDPOINT_IMAGE = BASEURL + "/image/";

var IMGUR_IMG_URL = "http://i.imgur.com/";

// OAUTH
var AUTHORIZE_URL = "https://api.imgur.com/oauth2/authorize"
var ACCESS_TOKEN_URL = "https://api.imgur.com/oauth2/token"
var OAUTH_CONSUMER_KEY;
var OAUTH_CONSUMER_SECRET;
var OAUTH_ACCESS_TOKEN;
var OAUTH_REFRESH_TOKEN;
var USER_AGENT;

// needs sign in
var ENDPOINT_ACCOUNT = BASEURL + "/account";
var ENDPOINT_ACCOUNT_CURRENT = ENDPOINT_ACCOUNT + "/me";
var ENDPOINT_ACCOUNT_CURRENT_IMAGES = ENDPOINT_ACCOUNT_CURRENT + "/me/images";
var ENDPOINT_COMMENT = BASEURL + "/comment";

function init(client_id, client_secret, access_token, refresh_token, user_agent) {
    //console.debug("imgur.js, init: client_id=" + client_id + "; client_secret=" + client_secret + "; access_token=" + access_token + "; refresh_token=" + refresh_token + "; user_agent=" + user_agent);
    OAUTH_CONSUMER_KEY = client_id;
    OAUTH_CONSUMER_SECRET = client_secret;
    OAUTH_ACCESS_TOKEN = access_token;
    OAUTH_REFRESH_TOKEN = refresh_token;
    USER_AGENT = user_agent;
}

/*
Gallery
Returns the images in the gallery. For example the main gallery is https://api.imgur.com/3/gallery/hot/viral/0.json

https://api.imgur.com/3/gallery/{section}/{sort}/{window}/{page}?showViral=bool

section     optional 	hot | top | user - defaults to hot
sort        optional 	viral | time - defaults to viral
page        optional 	integer - the data paging number
window      optional 	Change the date range of the request if the section is "top",
                        day | week | month | year | all, defaults to day
showViral 	optional 	true | false - Show or hide viral images from the 'user' section. Defaults to true
*/
function getGallery(model, page, settings, onSuccess, onFailure) {
    var url = ENDPOINT_GALLERY;
    url += "/" + settings.section + "/" + settings.sort + "/" + settings.window + "/" + page + "/?showViral=" + settings.showViral;

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
window	optional	Change the date range of the request if the sort is "top",
                    day | week | month | year | all, defaults to week
*/
function getMemesSubGallery(model, page, settings, onSuccess, onFailure) {
    var url = ENDPOINT_GET_GALLERY_MEMES;
    url += "/" + settings.sort + "/" + settings.window + "/" + page;
    url += "/" + page;

    sendJSONRequest(url, 1, model, onSuccess, onFailure);
}

/**
Subreddit Galleries
View gallery images for a subreddit

Route:	https://api.imgur.com/3/gallery/r/{subreddit}/{sort}/{page}
        https://api.imgur.com/3/gallery/r/{subreddit}/{sort}/{window}/{page}

Response Model:	Gallery Images with 'reddit_comments' url

Key         Required	Value
subreddit	required	pics - A valid subreddit name
sort        optional	time | top - defaults to time
page        optional	integer - the data paging number
window      optional	Change the date range of the request if the sort is "top",
                        day | week | month | year | all, defaults to week
*/
function getRedditSubGallery(model, page, settings, onSuccess, onFailure) {
    // Url prone to change due to shifting subreddit interests...
    var url = ENDPOINT_GALLERY + "/r/" + settings.redditSub;
    url += "/" + settings.sort + "/" + settings.window + "/" + page;

    sendJSONRequest(url, 1,  model, onSuccess, onFailure);
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
                } else if (actiontype === 5) {
                    handleCommentJSON(xhr.responseText, model);
                } else if (actiontype === "albums") {
                    handleAlbumsJSON(xhr.responseText, model);
                } else if (actiontype === "images") {
                    handleImagesJSON(xhr.responseText, model);
                }
                //console.log("RateLimit: user=" + creditsUserRemaining  + ", client=" + creditsClientRemaining);
                onSuccess(xhr.status);
            } else {
                //console.log("error: " + xhr.status+"; "+ xhr.responseText);
                try {
                    var jsonObject = JSON.parse(xhr.responseText);
                    onFailure(xhr.status, xhr.statusText + ": " + jsonObject.data.error);
                } catch (err) {
                    onFailure(500, "Error getting data from imgur: " + err );
                }
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
    //console.debug("getGallerySearch, url=" + url);

    sendJSONRequest(url, 1, model, onSuccess, onFailure);
}

// get gallery album
function getGalleryAlbum(id, model, albumModel, onSuccess, onFailure) {
    var url = ENDPOINT_GALLERY_ALBUM;
    url += "/" + id;

    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                handleGalleryAlbumJSON(xhr.responseText, model, albumModel);
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

// get album
function getAlbum(id, model, albumModel, onSuccess, onFailure) {
    var url = ENDPOINT_ALBUM;
    url += "/" + id;

    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                handleGalleryAlbumJSON(xhr.responseText, model, albumModel);
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


// get gallery image
function getGalleryImage(id, model, albumModel, onSuccess, onFailure) {
    var url = redditModeActive ? ENDPOINT_IMAGE : ENDPOINT_GALLERY_IMAGE;
    url += "/" + id;

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

    for (var i in jsonObject.data) {
        var output = jsonObject.data[i];
        var ext = 'jpg';
        var link = IMGUR_IMG_URL;
        var linkLarge = output.link;
        var id = "";

        if (output.is_album === false) {
            id = output.id;
        } else {
            id = output.cover;
        }

        link += id+"b."+ext; // s=90x90, b=160x160, t=160x160 (aspect)

        var title = "";
        if (output.title) {
            title = output.title;
        }
        var vote = "";
        if (output.vote) {
            vote = output.vote;
        }

        if (output.nsfw !== true || model.showNsfw === true) {
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
}

/*
    Parse JSON for Albums.
*/
function handleAlbumsJSON(response, model) {
    var jsonObject = JSON.parse(response);

    for (var i in jsonObject.data) {
        var output = jsonObject.data[i];
        var ext = 'jpg';
        var link = IMGUR_IMG_URL;
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

    for (var i in jsonObject.data) {
        var output = jsonObject.data[i];
        var ext = 'jpg';
        var link = IMGUR_IMG_URL;
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

    var data = jsonObject.data;
    for (var i in jsonObject.data.images) {
        //console.debug(JSON.stringify(jsonObject.data.images[i]))
        fillAlbumImagesModel(jsonObject.data.images[i], model);
    }

    fillAlbumVariables(data, albumModel);
}

/*
  Parse JSON for Image and fill albumModel.
  https://api.imgur.com/models/gallery_image
*/
function handleGalleryImageJSON(response, model, albumModel) {
    var jsonObject = JSON.parse(response);

    fillAlbumImagesModel(jsonObject.data, model);
    fillAlbumVariables(jsonObject.data, albumModel);
}

function fillAlbumImagesModel(output, model) {
    var title = setVariable(output.title);
    var description = setVariable(output.description);
    var link;
    var link_original;

    if (output.link) {
        link_original = output.link;
        link = output.link;
    }

    var imageData = {
        id: output.id,
        title: title,
        description: replaceURLWithHTMLLinks(description),
        datetime: (output.datetime) ? formatEpochDatetime(output.datetime) : "",
        animated: output.animated,
        type: output.type,
        vWidth: output.width,
        vHeight: output.height,
        size: (output.size) ? humanFileSize(output.size) : "",
        views: output.views,
        bandwidth: (output.bandwidth) ? humanFileSize(output.bandwidth) : "",
        link: link,
        link_original: link_original,
        ups: (output.ups) ? output.ups : 0,
        downs: (output.downs) ? output.downs : 0,
        section: (output.section) ? output.section : "",
        nsfw: (output.nsfw) ? output.nsfw : false,
        gifv: (output.gifv) ? output.gifv : "",
        mp4: (output.mp4) ? output.mp4 : "",
        webm: (output.webm) ? output.webm : "",
        looping: (output.looping) ? output.looping : false
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


    model.info = "";
    if (model.account_url !== "") {
        model.info += qsTr("by") + " " + model.account_url + " at ";
    }
    model.info += model.datetime + ". " + model.views + " " + qsTr("views");

    //console.log("score=" + score + "; total=" + total + "; ups=" + ups + "; downs=" + downs + " upsPercent=" + upsPercent + "; downsPercent="  + downsPercent);
}

function handleCommentsJSON(response, model) {
    var jsonObject = JSON.parse(response);

    for (var i in jsonObject.data) {
        var output = jsonObject.data[i];
        parseComments(output, 0, model);
    }

}

function handleCommentJSON(response, model) {
    var jsonObject = JSON.parse(response);
    var output = jsonObject.data;
    //console.log("handleCommentJSON " + JSON.stringify(output));
    parseComment(output, model);
}

function parseComments(output, depth, model) {
    var childrens = parseInt(output.children.length);

    if (output.nsfw !== true || model.showNsfw === true) {
        addCommentToModel(output, depth, model)
    }

    //console.log("childrens: " + JSON.stringify(output.children));

    if (childrens > 0) {
        depth += 1;
        for (var j=0; j < childrens; j++) {
            var points = parseInt(output.children[j].points);
            //if ( points >= 0) {
                parseComments(output.children[j], depth, model);
            //}
        }
    }
}

function addCommentToModel(output, depth, model) {
    var date = formatEpochDatetime(output.datetime);

    var vote = (output.vote) ? output.vote : "vote";
    model.push({
                   id: output.id,
                   comment: replaceURLWithHTMLLinks(output.comment),
                   author: output.author,
                   ups: output.ups,
                   downs: output.downs,
                   points: output.points,
                   datetime: date,
                   //children: output.children,
                   depth: depth,
                   vote: vote
    });
}

function parseComment(output, model) {
    addCommentToModel(output, 0, model);
}


/**
Replies
Get the comment with all of the replies for the comment.
Method          GET
Route           https://api.imgur.com/3/comment/{id}/replies
Response Model	Comment
*/
function getCommentReplies(id, model, onSuccess, onFailure) {
    var url = ENDPOINT_COMMENT + "/" + id + "/replies";

    sendJSONRequest(url, 4, model, onSuccess, onFailure);
}

/**
Comment
Get information about a specific comment.

Method          GET
Route           https://api.imgur.com/3/comment/{id}
Response Model	Comment
*/
function getComment(id, model, onSuccess, onFailure) {
    var url = ENDPOINT_COMMENT + "/" + id;

    sendJSONRequest(url, 5, model, onSuccess, onFailure);
}

/**
  Get user info.

Account Base
Request standard user information. If you need the username for the account that is logged in,
it is returned in the request for an access token.
Method	GET
Route	https://api.imgur.com/3/account/{username}
Response Model	Account
*/
function getAccount(username, onSuccess, onFailure) {
    var url = ENDPOINT_ACCOUNT + "/" + username;

    var xhr = new XMLHttpRequest();
    xhr.open('GET', url);
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            //console.log("headers: " + xhr.getAllResponseHeaders());
            if (xhr.status == 200) {
                var jsonObject = JSON.parse(xhr.responseText);
                //console.log("response: " + JSON.stringify(jsonObject));
                onSuccess(jsonObject.data, xhr.status);
            } else {
                //console.log(xhr.status, xhr.statusText, xhr.responseText);
                jsonObject = JSON.parse(xhr.responseText);
                onFailure(xhr.status, xhr.statusText + ": " + jsonObject.data.error);
            }
        }
    }

    xhr = createGETHeader(xhr);
    xhr.send();
}

function createGETHeader(xhr) {
    if (OAUTH_ACCESS_TOKEN === "") {
        xhr.setRequestHeader("Authorization", "Client-ID " + OAUTH_CONSUMER_KEY);
    } else {
        xhr.setRequestHeader("Authorization", "Bearer " + OAUTH_ACCESS_TOKEN);
    }

    xhr.setRequestHeader("User-Agent", USER_AGENT);
    return xhr;
}

function getAuthorizationHeader() {
    if (OAUTH_ACCESS_TOKEN === "") {
        return "Client-ID " + OAUTH_CONSUMER_KEY;
    } else {
        return "Bearer " + OAUTH_ACCESS_TOKEN;
    }
}

function processGalleryMode(query, model, page, settings, onSuccess, onFailure) {
    // Global accesor used to use the correct URL base for getGalleryImage()
    redditModeActive = false;

    if (query) {
        getGallerySearch(query, model, page, settings, onSuccess, onFailure);
    }
    else if (settings.mode === "main" || settings.mode === "user" || settings.mode === "score") {
        getGallery(model, page, settings, onSuccess, onFailure);
    } else if (settings.mode === "random") {
        getRandomGalleryImages(model, page, onSuccess, onFailure);
    } else if (settings.mode === "memes") {
        getMemesSubGallery(model, page, settings, onSuccess, onFailure);
    } else if (settings.mode === "reddit") {
        redditModeActive = true;
        getRedditSubGallery(model, page, settings, onSuccess, onFailure);

    } else if (settings.mode === "favorites") {
        getFavorites(model, onSuccess, onFailure);
    } else if (settings.mode === "albums") {
        getAlbums(model, page, onSuccess, onFailure);
    } else if (settings.mode === "images") {
        getImages(model, page, onSuccess, onFailure);
    }
}

