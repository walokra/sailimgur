.pragma library

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
        if (xhr.readyState === XMLHttpRequest.DONE) {
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

/**
Vote
Vote on a comment. The {vote} variable can only be set as "up" or "down".
Method          POST
Route           https://api.imgur.com/3/comment/{id}/vote/{vote}
Response Model	Basic
*/
function commentVote(id, vote, onSuccess, onFailure) {
    var url = ENDPOINT_COMMENT + "/" + id + "/vote/" + vote;
    sendJSONPOSTRequest(url, onSuccess, onFailure);
}

/**
Comment Creation
Creates a new comment, returns the ID of the comment.

Method          POST
Route           https://api.imgur.com/3/comment
Response Model	Basic

Parameters
image_id        required	The ID of the image in the gallery that you wish to comment on
comment         required	The comment text, this is what will be displayed
parent_id       optional	The ID of the parent comment, this is an alternative method to create a reply.
*/
function commentCreation(image_id, comment, parent_id, onSuccess, onFailure) {
    var url = ENDPOINT_COMMENT;
    if (parent_id) {
         url += "/" + parent_id;
    }

    var message = "image_id=" + image_id + "&" + "comment=" + comment;
    sendJSONPOSTMessageRequest(url, message, onSuccess, onFailure);
}

/**
Comment Deletion
Delete a comment by the given id.

Method          DELETE
Route           https://api.imgur.com/3/comment/{id}
Response Model	Basic
*/
function commentDeletion(id, onSuccess, onFailure) {
    var url = ENDPOINT_COMMENT + "/" + id;

    sendJSONDELETERequest(url, onSuccess, onFailure);
}

/**
Reply Creation
Create a reply for the given comment.

Method          POST
Route           https://api.imgur.com/3/comment/{id}
Response Model	Basic

Parameters
image_id	required	The ID of the image in the gallery that you wish to comment on
comment     required	The comment text, this is what will be displayed
*/
/*
function commentReply(image_id, comment, id, onSuccess, onFailure) {
    var url = ENDPOINT_COMMENT + "/" + id;
    //sendJSONPOSTRequest(url, image_id, comment, onSuccess, onFailure);
}
*/

/**
Submit to Gallery
Add an Album or Image to the Gallery.

Method	POST | PUT
Route	https://api.imgur.com/3/gallery/image/{id}
Route	https://api.imgur.com/3/gallery/album/{id}
Route	https://api.imgur.com/3/gallery/{id}

Response Model	Gallery Image OR Gallery Album

Parameters
Key     Required	Value
title	required	The title of the image. This is required.
terms	optional	If the user has not accepted our terms yet, this endpoint will return an error.
                    To by-pass the terms in general simply set this value to 1.
*/
function submitToGallery(id, title, onSuccess, onFailure) {
    var url = ENDPOINT_GALLERY_IMAGE + "/" + id;
    var message = "title=" + title + "&" + "terms=" + 1;
    sendJSONPOSTMessageRequest(url, message, onSuccess, onFailure);
}

/**
Image Deletion
    Deletes an image. For an anonymous image, {id} must be the image's deletehash.
    If the image belongs to your account then passing the ID of the image is sufficient.

Method	DELETE
Route	https://api.imgur.com/3/image/{id}

Response Model	Basic
*/
function imageDeletion(id, onSuccess, onFailure) {
    var url = ENDPOINT_IMAGE + "/" + id;

    sendJSONDELETERequest(url, onSuccess, onFailure);
}

/**
Album Deletion
    Delete an album with a given ID. You are required to be logged in as the user to delete the album.
    Takes parameter, ids[], as an array of ids and removes from the labum.
    For anonymous albums, {album} should be the deletehash that is returned at creation.

Method	DELETE
Route	https://api.imgur.com/3/album/{album}

Response Model	Basic
*/
function albumDeletion(id, onSuccess, onFailure) {
    var url = ENDPOINT_ALBUM + "/" + id;

    sendJSONDELETERequest(url, onSuccess, onFailure);
}

function sendJSONPOSTMessageRequest(url, message, onSuccess, onFailure) {
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
       xhr.setRequestHeader("Content-length", message.length);
       xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
       xhr.setRequestHeader("User-Agent", USER_AGENT);
    }

   xhr.send(message);
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

function sendJSONDELETERequest(url, onSuccess, onFailure) {
    var xhr = new XMLHttpRequest();

    xhr.open("DELETE", url, true);
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
       xhr.setRequestHeader("Authorization", "Client-ID " + OAUTH_CONSUMER_KEY);
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
