import QtQuick 2.0
import "../components/imgur.js" as Imgur

ListModel {
    id: listModel;

    property bool loaded : false;
    property bool busy : false;

    property string query : "";
    property bool addToList : false;

    function nextPage(searchText) {
        processGalleryMode(searchText);
    }

    function processGalleryMode(searchText) {
        busy = true;
        loaded = false;
        loadingRect.visible = true;
        signInPage.refreshDone = false;
        if (searchText) {
            query = searchText;
        } else {
            query = "";
        }

        signInPage.init();

       Imgur.processGalleryMode(query, listModel, page, settings,
            onSuccess(),
            onFailure()
        );
    }

    function onSuccess() {
        return function(status) {
            if(currentIndex === -1) {
                currentIndex = listModel.count - 1;
            }
            galleryContentPage.load();
            loadingRect.visible = false;
            loaded = true;
            busy = false;
        }
    }

    function onFailure(){
        return function(status, statusText) {
            if (status === 403 && signInPage.refreshDone == false) {
                signInPage.tryRefreshingTokens(
                    function() {
                    });
            } else {
                infoBanner.showHttpError(status, statusText);
            }
            loadingRect.visible = false;
            busy = false;
            loaded = true;
        }
    }

}
