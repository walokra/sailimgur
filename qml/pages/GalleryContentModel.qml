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
    }

    function callImgur(mode, id, is_gallery) {
        if (is_gallery) {
            if (mode === "album") {
                Imgur.getGalleryAlbum(id, allImages, listModel,
                                      onSuccess(settings.albumImagesLimit),
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
                               onSuccess(settings.albumImagesLimit),
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

    function getNextImages(initialLimit) {
        var start = 0;
        var end = allImages.length;
        if (!isSlideshow) {
            start = (initialLimit) ? 0 : listModel.count;
            index += 1;
            end = (initialLimit) ? initialLimit : listModel.count + settings.albumImagesSlice;
        }
        //console.log("start=" + start + "; end=" + end + "; total=" + allImages.length);
        listModel.append(allImages.slice(start, end));

        total = allImages.length;
        left = total - listModel.count;
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
