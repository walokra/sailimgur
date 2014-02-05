var OAUTH_CONSUMER_KEY
var OAUTH_CONSUMER_SECRET
var OAUTH_TOKEN
var OAUTH_TOKEN_SECRET
var USER_AGENT

// OAUTH
var ADD_CLIENT_URL = "https://api.imgur.com/oauth2/addclient"
var REQUEST_TOKEN_URL = "https://api.imgur.com/oauth2/authorize"
var ACCESS_TOKEN_URL = "https://api.imgur.com/oauth2/token"

var BASEURL = "https://api.imgur.com/3";

// GET
// http://api.imgur.com/endpoints/gallery
// https://api.imgur.com/3/gallery/{section}/{sort}/{page}?showViral=bool
var ENDPOINT_GET_GALLERY_MAIN = BASEURL + "/" + "gallery";
// https://api.imgur.com/3/gallery/random/random/{page}
var ENDPOINT_GET_GALLERY_RANDOM = BASEURL + "/" + "gallery/random/random";
// https://api.imgur.com/3/gallery/g/memes/{sort}/{window}/{page}
var ENDPOINT_GET_GALLERY_MEMES = BASEURL + "/" + "gallery/g/memes";
var ENDPOINT_GET_GALLERY_IMAGE = BASEURL + "/" + "gallery/image"
var ENDPOINT_GET_GALLERY_ALBUM = BASEURL + "/" + "gallery/album";
var ENDPOINT_GET_GALLERY = BASEURL + "/" + "gallery";
// https://api.imgur.com/3/gallery/search/{sort}/{page}?q=string
var ENDPOINT_GET_GALLERY_SEARCH = BASEURL + "/gallery/search";
var ENDPOINT_GET_CREDITS = BASEURL + "/credits";

var reloadGalleryPage = false;

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
function getGallery() {
    galleryModel.clear();

    var url = ENDPOINT_GET_GALLERY_MAIN;
    url += "/" + settings.section + "/" + settings.sort + "/" + settings.window + "/" + page + "/?showViral=" + settings.showViral;
    //console.log("getGallery: " + url);
    sendJSONRequest(url, 1);
}

/*
Random Gallery Images
Returns a random set of gallery images.

https://api.imgur.com/3/gallery/random/random/{page}

page 	optional 	A page of random gallery images, from 0-50. Pages are regenerated every hour.
*/
function getRandomGalleryImages() {
    galleryModel.clear();

    var xhr = new XMLHttpRequest();
    var url = ENDPOINT_GET_GALLERY_RANDOM;
    url += "/" + page;
    //console.log("getRandomGalleryImages: " + url);

    sendJSONRequest(url, 1);
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
function getMemesSubGallery() {
    galleryModel.clear();

    var xhr = new XMLHttpRequest();
    var url = ENDPOINT_GET_GALLERY_MEMES;
    url += "/" + settings.sort + "/" + settings.window + "/" + page;
    url += "/" + page;

    sendJSONRequest(url, 1);
}

function sendJSONRequest(url, actiontype) {
    var xhr = new XMLHttpRequest();

    if (actiontype === 4) {
        loadingRectComments.visible = true;
    }

    xhr.open("GET", url, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            if (xhr.status == 200) {
                //console.log("ok");
                if (actiontype === 1) {
                    handleGalleryJSON(xhr.responseText);
                } else if (actiontype === 2) {
                    handleAlbumJSON(xhr.responseText);
                } else if (actiontype === 3) {
                    handleImageJSON(xhr.responseText);
                } else if (actiontype === 4) {
                    handleCommentsJSON(xhr.responseText);
                } else if (actiontype === 5) {
                    handleCreditsJSON(xhr.responseText);
                }
                creditsUserRemaining = xhr.getResponseHeader("X-RateLimit-UserRemaining");
                creditsClientRemaining = xhr.getResponseHeader("X-RateLimit-ClientRemaining");
                //console.log("RateLimit: user=" + creditsUserRemaining  + ", client=" + creditsClientRemaining);
            } else {
                //console.log("error: " + xhr.status+"; "+xhr.responseText);
                infoBanner.showHttpError(xhr.status, xhr.responseText);
                loadingRect.visible = false;
            }
        }
    }
    // Send the proper header information along with the request
    xhr.setRequestHeader("Authorization", "Client-ID " + settings.client_id);

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
function getGallerySearch(query) {
    galleryModel.clear();

    var xhr = new XMLHttpRequest();
    var url = ENDPOINT_GET_GALLERY_SEARCH;
    url += "/" + settings.sort + "/" + page + "/?q=" + query;
    //console.log("getGallerySearch: " + url);

    sendJSONRequest(url, 1);
}

// get gallery album
function getAlbum(id) {
    albumImagesModel.clear();
    albumImagesMoreModel.clear();
    commentsModel.clear();

    var xhr = new XMLHttpRequest();
    var url = ENDPOINT_GET_GALLERY_ALBUM;
    url += "/" + id;
    //console.log("getAlbum: " + url);

    sendJSONRequest(url, 2);
}

// get gallery image
function getGalleryImage(id) {
    albumImagesModel.clear();
    albumImagesMoreModel.clear();
    commentsModel.clear();

    var xhr = new XMLHttpRequest();
    var url = ENDPOINT_GET_GALLERY_IMAGE;
    url += "/" + id;
    //console.log("getGalleryImage: " + url);

    sendJSONRequest(url, 3);
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
function getAlbumComments(id) {
    var xhr = new XMLHttpRequest();
    var url = ENDPOINT_GET_GALLERY;
    url += "/" + id + "/comments";
    //console.log("getGalleryImage: " + url);

    sendJSONRequest(url, 4);
}

/**
  Check the current rate limit status
*/
function getCredits() {
    var url = ENDPOINT_GET_CREDITS;
    sendJSONRequest(url, 5);
}

/*
    Parse JSON for main Gallery (main, search, random) and fill galleryModel.
*/
function handleGalleryJSON(response) {
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

        galleryModel.append({
                            id: output.id,
                            title: title,
                            link: link,
                            is_album: output.is_album
                         });
    }

    onLoading();
}

function onLoading() {
    loadingRect.visible = false;
    if(currentIndex == -1) {
        currentIndex = galleryModel.count - 1;
    }
    if (reloadGalleryPage) {
        galleryPage.load();
    }
}

function fillAlbumImagesModel(output, toMoreModel) {
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

    if (toMoreModel) {
        // https://api.imgur.com/models/image/
        albumImagesMoreModel.append({
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
                        });
    } else {
        albumImagesModel.append({
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
                            });
    }
}

function fillGalleryVariables(output) {
    if (output.account_url) {
        account_url = output.account_url;
    }
    views = output.views;
    ups = output.ups;
    downs = output.downs;
    score = output.score;
    images_count = 0;
    if (output.images_count) {
        images_count = output.images_count;
    }
    if(output.is_album) {
        is_album = output.is_album;
    } else {
        is_album = false;
    }

    var total = parseInt(ups) + parseInt(downs);
    upsPercent = Math.floor(100 * (ups/total));
    downsPercent = Math.ceil(100 * (downs/total));

    //console.log("score=" + score + "; total=" + total + "; ups=" + ups + "; downs=" + downs + " upsPercent=" + upsPercent + "; downsPercent="  + downsPercent);
}

/*
  Parse JSON for Gallery Album and fill albumImagesModel.
  https://api.imgur.com/models/gallery_album
*/
function handleAlbumJSON(response) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));

    var data = jsonObject.data;
    //console.log("data.is_album=" + data.is_album + "; data.images_count=" + data.images_count + "; albumImagesLimit=" + settings.albumImagesLimit);
    for (var i in jsonObject.data.images) {
        //console.log("image[" + i + "]=" + JSON.stringify(jsonObject.data.images[i]));
        //console.log("output=" + JSON.stringify(output));

        if (i > settings.albumImagesLimit) {
            fillAlbumImagesModel(jsonObject.data.images[i], true);
        }
        else {
            fillAlbumImagesModel(jsonObject.data.images[i], false);
        }
    }
    //console.log("count=" + albumImagesModel.count);

    fillGalleryVariables(data);
}

/*
  Parse JSON for Image and fill albumImagesModel.
  https://api.imgur.com/models/gallery_image
*/
function handleImageJSON(response) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));

    fillAlbumImagesModel(jsonObject.data, false, 1);
    fillGalleryVariables(jsonObject.data);
}

function handleCommentsJSON(response) {
    var jsonObject = JSON.parse(response);
    //console.log("comments: " + JSON.stringify(jsonObject));

    for (var i in jsonObject.data) {
        var output = jsonObject.data[i];
        parseComments(output, 0);
    }

    //console.log("comments=" + commentsModel.count);
    loadingRectComments.visible = false;
}

function handleCreditsJSON(response) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));
    //console.log("output=" + JSON.stringify(jsonObject));

    var data = jsonObject.data;
    //console.log("output=" + JSON.stringify(data));
    creditsUserRemaining = data.UserRemaining;
    creditsClientRemaining = data.ClientRemaining;
}

function parseComments(output, depth) {
    var date = new Date(output.datetime * 1000);
    var datetime = date.getHours() + ":" +
            date.getMinutes() + ":" +
            date.getSeconds() + ", " +
            date.getFullYear() + "-" + date.getMonth() + 1 + "-" + date.getDate();

    var childrens = parseInt(output.children.length);
    commentsModel.append({
                        id: output.id,
                        comment: replaceURLWithHTMLLinks(output.comment),
                        author: output.author,
                        ups: output.ups,
                        downs: output.downs,
                        points: output.points,
                        datetime: datetime,
                        children: output.children,
                        childrens: childrens,
                        depth: depth
                     });

    // console.log("childrens: " + JSON.stringify(output.children));

    if (childrens > 0) {
        depth += 1;
        for (var j=0; j < childrens; j++) {
            if (output.children[j].points > 1) {
                parseComments(output.children[j], depth);
            }
        }
    }
}

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

function processGalleryMode(refreshGallery, query) {
    if (refreshGallery) {
        reloadGalleryPage = true;
    }else {
        reloadGalleryPage = false;
    }

    loadingRect.visible = true;
    if (query) {
        getGallerySearch(query);
    }
    else if (settings.mode === "main") {
        getGallery();
    } else if (settings.mode === "random") {
        getRandomGalleryImages();
    } else if (settings.mode === "user") {
        getGallery();
    } else if (settings.mode === "score") {
        getGallery();
    } else if (settings.mode === "memes") {
        getMemesSubGallery();
    }
}
