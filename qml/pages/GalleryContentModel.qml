import QtQuick 2.0
import "../components/imgur.js" as Imgur

ListModel {
    id: listModel;

    // Gallery props
    property string account_url : "";
    property string views : "0";
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

    function getAlbum(id, is_gallery) {
        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);

        if (is_gallery) {
            Imgur.getGalleryAlbum(id, allImages, listModel,
                                  function(status){
                                      loaded = true;
                                      getNextImages(settings.albumImagesLimit);
                                  }, function(status, statusText){
                                      loaded = true;
                                      infoBanner.showHttpError(status, statusText);
                                  }
            );
        } else {
            Imgur.getAlbum(id, allImages, listModel,
                           function(status){
                               loaded = true;
                               getNextImages(settings.albumImagesLimit);
                           }, function(status, statusText){
                               loaded = true;
                               infoBanner.showHttpError(status, statusText);
                           }
            );
        }

        total = allImages.length;
        left = total;
    }

    function getImage(id, is_gallery) {
        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);

        if (is_gallery) {
            Imgur.getGalleryImage(id, allImages, listModel,
                                  function(status){
                                      loaded = true;
                                      getNextImages();
                                  }, function(status, statusText){
                                      loaded = true;
                                      infoBanner.showHttpError(status, statusText);
                                  }
            );
        } else {
            Imgur.getImage(id, allImages, listModel,
                                function(status){
                                    loaded = true;
                                    getNextImages();
                                }, function(status, statusText){
                                    loaded = true;
                                    infoBanner.showHttpError(status, statusText);
                                }
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

}
