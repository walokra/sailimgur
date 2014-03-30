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

    //
    property int index : 0;
    property var allImages : [];
    property int total : 0;
    property int left : 0;

    property bool loaded: false;
    property bool refreshDone : false;

    function getAlbum(id, is_gallery) {
        signInPage.init();

        if (is_gallery) {
            var getGalleryAlbum = Imgur.getGalleryAlbum(id, allImages, listModel,
                onSuccess(settings.albumImagesLimit),
                onFailure(getGalleryAlbum)
            );
        } else {
            var getAlbum = Imgur.getAlbum(id, allImages, listModel,
                onSuccess(settings.albumImagesLimit),
                onFailure(getAlbum)
            );
        }

        total = allImages.length;
        left = total;
    }

    function getImage(id, is_gallery) {
        signInPage.init();

        if (is_gallery) {
            var getGalleryImage = Imgur.getGalleryImage(id, allImages, listModel,
                onSuccess(),
                onFailure(getGalleryImage)
            );
        } else {
            var getImage = Imgur.getImage(id, allImages, listModel,
                onSuccess(),
                onFailure(getImage)
            );
       }
    }

    function getNextImages(initialLimit) {
        var start = (initialLimit) ? 0 : listModel.count;
        index += 1;
        var end = (initialLimit) ? initialLimit : listModel.count + settings.albumImagesSlice;
        //start = (start >= allComments.length) ? allComments.length : start;
        //end = (end > allComments.length) ? allComments.length : end;
        //console.log("start=" + start + "; end=" + end + "; total=" + allImages.length);
        listModel.append(allImages.slice(start, end));

        total = allImages.length;
        left = total - listModel.count;

        showMoreItem.visible = listModel.count < listModel.total;
    }

    function onSuccess(albumImagesLimit) {
        return function(status) {
            loaded = true;
            getNextImages(albumImagesLimit);
        }
    }

    function onFailure(func){
        return function(status, statusText) {
            if (status === 403 && refreshDone == false) {
                refreshDone = true;
                signInPage.tryRefreshingTokens(
                    function() {
                        refreshDone = false; // new tokens, we can retry later again
                        // retry the api call
                        func();
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
