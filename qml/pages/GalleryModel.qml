import QtQuick 2.0
import "../components/imgur.js" as Imgur

ListModel {
    id: listModel;

    property bool loaded: false;

    property string query : "";

    function processGalleryMode(searchText, index) {
        loaded = false;
        if (searchText) {
            query = searchText;
        } else {
            query = "";
        }

        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);

        loadingRect.visible = true;
        listModel.clear();

        Imgur.processGalleryMode(query, listModel, page, settings,
            function(status){
                if(index === -1) {
                    currentIndex = listModel.count - 1;
                }
                galleryContentPage.load();
                loadingRect.visible = false;
                loaded = true;
            }, function(status, statusText){
                infoBanner.showHttpError(status, statusText);
                loadingRect.visible = false;
                loaded = true;
            }
        );
    }

}
