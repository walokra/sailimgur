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

    property bool loaded: false;

    function getAlbum(id) {
        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);

        Imgur.getAlbum(id, listModel, albumImagesMoreModel, settings.albumImagesLimit,
            function(status){

            }, function(status, statusText){
                infoBanner.showHttpError(status, statusText);
            }
        );
    }

    function getGalleryImage(id) {
        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);

        Imgur.getGalleryImage(id, listModel,
            function(status){

             }, function(status, statusText){
                 infoBanner.showHttpError(status, statusText);
             }
        );
    }
}
