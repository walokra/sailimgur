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

    function getAlbum(id) {
        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);

        Imgur.getAlbum(id, allImages, listModel,
            function(status){
                loaded = true;
                getNextImages();
            }, function(status, statusText){
                loaded = true;
                infoBanner.showHttpError(status, statusText);
            }
        );
        total = allImages.length;
        left = total;
    }

    function getGalleryImage(id) {
        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);

        Imgur.getGalleryImage(id, allImages, listModel,
            function(status){
                loaded = true;
                getNextImages();
             }, function(status, statusText){
                 loaded = true;
                 infoBanner.showHttpError(status, statusText);
             }
        );
    }

    function getNextImages() {
        var start = index * settings.albumImagesSlice;
        index += 1;
        var end = index * settings.albumImagesSlice;
        //start = (start >= allComments.length) ? allComments.length : start;
        //end = (end > allComments.length) ? allComments.length : end;
        //console.log("start=" + start + "; end=" + end + "; total=" + allComments.length);
        listModel.append(allImages.slice(start, end));

        total = allImages.length;
        left = total - listModel.count;
    }

}
