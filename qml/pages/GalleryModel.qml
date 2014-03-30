import QtQuick 2.0
import "../components/imgur.js" as Imgur

ListModel {
    id: listModel;

    property bool loaded: false;

    property string query : "";
    property bool refreshDone : false;

    function processGalleryMode(searchText) {
        loaded = false;
        refreshDone = false;
        if (searchText) {
            query = searchText;
        } else {
            query = "";
        }

        signInPage.init();

        loadingRect.visible = true;
        listModel.clear();

        var processGalleryMode = Imgur.processGalleryMode(query, listModel, page, settings,
                onSuccess(),
                onFailure(processGalleryMode)
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
