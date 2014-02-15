import QtQuick 2.0
import "../components/imgur.js" as Imgur

ListModel {
    id: listModel;

    property bool loaded: false;

    function getComments(id) {
        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);

        Imgur.getGalleryComments(id, listModel,
                function(){
                    loadingRectComments.visible = false;
                }, function(status, statusText) {
                    loadingRectComments.visible = false;
                    infoBanner.showHttpError(status, statusText);
                }
        );
        loaded = true;
    }

}
