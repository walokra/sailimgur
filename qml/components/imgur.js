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

    var url = settings.endpoint_gallery_main;
    url += "/" + settings.section + "/" + settings.sort + "/" + settings.window + "/" + page + "/?showViral=" + settings.showViral;
    //console.log("getGallery: " + url);
    sendJSONRequest(url, 1);
}

function sendJSONRequest(url, actiontype) {
    var xhr = new XMLHttpRequest();

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
                }
                //infoBanner.showText("Fetched images from imgur.");
                console.log("RateLimit: user=" + xhr.getResponseHeader("X-RateLimit-UserRemaining")
                            + ", client=" + xhr.getResponseHeader("X-RateLimit-ClientRemaining"));
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
    var url = settings.endpoint_gallery_search;
    url += "/" + settings.sort + "/" + page + "/?q=" + query;
    //console.log("getGallerySearch: " + url);

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
    var url = settings.endpoint_gallery_random;
    url += "/" + page;
    //console.log("getRandomGalleryImages: " + url);

    sendJSONRequest(url, 1);
}

// get gallery album
function getAlbum(id) {
    albumImagesModel.clear();

    var xhr = new XMLHttpRequest();
    var url = settings.endpoint_gallery_album;
    url += "/" + id;
    //console.log("getAlbum: " + url);

    sendJSONRequest(url, 2);
}

// get gallery image
function getGalleryImage(id) {
    albumImagesModel.clear();

    var xhr = new XMLHttpRequest();
    var url = settings.endpoint_gallery_image;
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
    commentsModel.clear();

    var xhr = new XMLHttpRequest();
    var url = settings.endpoint_gallery;
    url += "/" + id + "/comments";
    //console.log("getGalleryImage: " + url);

    sendJSONRequest(url, 4);
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

function fillAlbumImagesModel(output) {
    var title = "";
    if (output.title) {
        title = output.title;
    }
    var description = "";
    if (output.description) {
        description = output.description;
    }
    var link = "";
    if (output.link) {
        link = output.link;
    }

    // https://api.imgur.com/models/image/
    albumImagesModel.append({
                            id: output.id,
                            title: title,
                            description: description,
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
    for (var i in jsonObject.data.images) {
        //console.log("image[" + i + "]=" + JSON.stringify(jsonObject.data.images[i]));
        //console.log("output=" + JSON.stringify(output));
        fillAlbumImagesModel(jsonObject.data.images[i]);
    }
    //console.log("count=" + albumImagesModel.count);

    fillGalleryVariables(data);

    loadingRect.visible = false;
}

/*
  Parse JSON for Image and fill albumImagesModel.
  https://api.imgur.com/models/gallery_image
*/
function handleImageJSON(response) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));

    fillAlbumImagesModel(jsonObject.data);
    fillGalleryVariables(jsonObject.data);

    loadingRect.visible = false;
}

function handleCommentsJSON(response) {
    var jsonObject = JSON.parse(response);
    //console.log("response: status=" + JSON.stringify(jsonObject.status) + "; success=" + JSON.stringify(jsonObject.success));
    //console.log("comments: " + JSON.stringify(jsonObject));

    for (var i in jsonObject.data) {
        var output = jsonObject.data[i];
        var hasChildren = false;
        if (output.children.length > 0) {
            hasChildren = true;
        }

        var date = new Date(output.datetime * 1000);
        var datetime = date.getHours() + ":" +
                date.getMinutes() + ":" +
                date.getSeconds() + ", " +
                date.getFullYear() + "-" + date.getMonth() + 1 + "-" + date.getDate();

        commentsModel.append({
                            id: output.id,
                            comment: replaceURLWithHTMLLinks(output.comment),
                            author: output.author,
                            ups: output.ups,
                            downs: output.downs,
                            points: output.points,
                            datetime: datetime,
                            children: output.children,
                            hasChildren: hasChildren
                         });
        //if (output.children.length > 0) {
        //    console.log("childrens: " + JSON.stringify(output.children));
        //}
    }

    //console.log("comments=" + commentsModel.count);
}

function getExt(link) {
    var ext = link.substr(link.lastIndexOf('.') + 1);
    return ext;
}

function processGalleryMode(refreshGallery) {
    if (refreshGallery) {
        reloadGalleryPage = true;
    }else {
        reloadGalleryPage = false;
    }

    loadingRect.visible = true;
    if (query) {
        getGallerySearch(query);
        pullDownMenu.close();
    }
    else if (settings.mode === "main") {
        //console.log("main");
        settings.galleryModeText = settings.galleryModeTextDefault;
        getGallery();
        pullDownMenu.close();
    } else if (settings.mode === "random") {
        //console.log("random");
        settings.galleryModeText = settings.galleryModeTextRandom;
        getRandomGalleryImages();
        pullDownMenu.close();
    }
}

function replaceURLWithHTMLLinks(text) {
    var exp = /(\b(https?):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
    return text.replace(exp,"<a href='$1'>$1</a>");
}
