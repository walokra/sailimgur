import QtQuick 2.0
import "../components/imgur.js" as Imgur

ListModel {
    id: listModel;

    // Album props
    property string account_url : "";
    property string views : "0";
    property string title : "";
    property string description : "";
    property string datetime;
    property string link : "";
    property string deletehash : "";
    property string imgur_id: "";
    property string info: "";

    // Gallery props
    property string ups : "0";
    property string downs : "0";
    property string score : "0";
    property string vote : "none";
    property bool favorite : false;
    property string images_count : "0";
    property int upsPercent : 0;
    property int downsPercent : 0;
    property bool is_album: false;
    property string gallery_page_link : "http://imgur.com";

    //
    property int index : 0;
    property var allImages : [];
    property int total : 0;
    property int left : 0;
    property int prev : 0;

    property bool loaded: false;

    property bool isSlideshow: false;

    function resetVariables() {
        // Album props
        account_url = "";
        views = "0";
        title = "";
        description = "";
        datetime = "";
        link = "";
        deletehash = "";
        info = "";

        // Gallery props
        ups = "0";
        downs = "0";
        score = "0";
        vote = "none";
        favorite = false;
        images_count = "0";
        upsPercent = 0;
        downsPercent = 0;
        is_album = false;

        index = 0;
        total = 0;
        left = 0;
        allImages = [];
        loaded = false;
        prev = 0;
    }

    function callImgur(mode, id, is_gallery) {
        if (is_gallery) {
            if (mode === "album") {
                Imgur.getGalleryAlbum(id, allImages, listModel,
                                      onSuccess(),
                                      onFailure(mode, id, is_gallery)
                                      );
            } else if (mode === "image") {
                Imgur.getGalleryImage(id, allImages, listModel,
                                      onSuccess(),
                                      onFailure(mode, id, is_gallery)
                 );
            }
        } else {
            if (mode === "album") {
                Imgur.getAlbum(id, allImages, listModel,
                               onSuccess(),
                               onFailure(mode, id, is_gallery)
                               );
            } else if (mode === "image") {
                Imgur.getImage(id, allImages, listModel,
                                onSuccess(),
                               onFailure(mode, id, is_gallery)
                );
            }
        }
    }

    function getAlbum(id, is_gallery) {
        //console.debug("getAlbum(" + id + ", " + is_gallery + ")");
        signInPage.init();
        callImgur("album", id, is_gallery);

        total = allImages.length;
        left = total;
    }

    function getImage(id, is_gallery) {
        signInPage.init();
        callImgur("image", id, is_gallery);
    }

    function getPrevImages() {
        index -= 1;
        var limit = settings.albumImagesLimit;
        var end = index * limit;
        total = allImages.length;
        var start = (end - limit) < 0 ? 0 : (end - limit);

        if (listModel.count > limit) {
            end = total - listModel.count;
            start = (end - limit) < 0 ? 0 : (end - limit);
        }
        prev = start;

        //console.log("start=" + start + "; end=" + end + "; total=" + allImages.length + "; index=" + index
        //            + "; prev=" + prev + "; left=" + left + "; limit=" + limit);

        listModel.clear();
        listModel.append(allImages.slice(start, end));
        left = total - end;
    }

    function getNextImages() {
        var limit = settings.albumImagesLimit;
        var start = 0;
        var end = allImages.length;
        total = allImages.length;
        if (!isSlideshow) {
            start = index * limit;
            index += 1;
            end = (start + limit) > total ? total : start + limit;
        }
        prev = (end - limit) < 0 ? 0 : (end - limit);

        //console.log("start=" + start + "; end=" + end + "; total=" + allImages.length + "; index=" + index
        //            + "; prev=" + prev + "; left=" + left + "; limit=" + limit);

        if (left >= limit) {
            listModel.clear();
            listModel.append(allImages.slice(start, end));
            left = total - end;
        } else {
            listModel.append(allImages.slice(start, end));
            if (listModel.count > limit) {
                prev = total - listModel.count;
                left = 0;
                index -= 1;
            } else {
                left = total - end;
            }
        }
        //console.log("prev=" + prev + "; left=" + left);

        if (listModel.count === total) {
            left = 0;
            prev = 0;
        }
    }

    function onSuccess(albumImagesLimit) {
        return function(status) {
            loaded = true;
            getNextImages(albumImagesLimit);
        }
    }

    function onFailure(mode, id, is_gallery){
        return function(status, statusText) {
            if (status === 403 && signInPage.refreshDone == false) {
                signInPage.tryRefreshingTokens(
                            function() {
                                return callImgur(mode, id, is_gallery);
                            }
                );
            } else {
                infoBanner.showHttpError(status, statusText);
                loadingRect.visible = false;
                loaded = true;
            }
        }
    }

}
