import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Rectangle {
    id: navBg;
    anchors { bottom: parent.bottom; left: parent.left; right: parent.right; }
    height: 80;
    z: 1;
    color: "black";
    opacity: 0.7;

    ListItem {
        id: navigationItem;

        Button {
            id: prev;
            text: qsTr("« Previous");

            height: Theme.itemSizeExtraSmall;
            anchors.left: parent.left;

            onClicked: {
                //console.log("Previous clicked! curr=" + currentIndex + "; page=" + page);
                if (currentIndex > 0 && page >= 0) {
                    currentIndex -= 1;
                    load();
                } else if (currentIndex === 0 && page >= 1) {
                    //console.log("Getting previous list of images");
                    page -= 1;

                    loadingRect.visible = true;
                    galleryModel.clear();
                    Imgur.processGalleryMode(settings.mode, "",
                        function(status){
                            galleryContentPage.load();
                            loadingRect.visible = false;
                            currentIndex = galleryModel.count - 1;
                        }, function(status, statusText){
                            infoBanner.showHttpError(status, statusText);
                            loadingRect.visible = false;
                        }
                    );
                }
                setPrevButton();
            }
            enabled: prevEnabled;
            visible: prevEnabled;
        }

        Button {
            id: next;
            text: qsTr("Next »");

            height: Theme.itemSizeExtraSmall;
            anchors.right: parent.right;

            onClicked: {
                //console.log("Next clicked! curr=" + currentIndex + "; model=" + galleryModel.count);
                if (currentIndex < galleryModel.count-1) {
                    //console.log("Getting next image");
                    currentIndex += 1;
                    load();
                }
                prevEnabled = true;
                if (currentIndex === galleryModel.count-1) {
                    //console.log("Getting new list of images");
                    page += 1;
                    currentIndex = 0;

                    loadingRect.visible = true;
                    galleryModel.clear();
                    Imgur.processGalleryMode(settings.mode, "",
                        function(status){
                            galleryContentPage.load();
                            loadingRect.visible = false;
                        }, function(status, statusText){
                            infoBanner.showHttpError(status, statusText);
                            loadingRect.visible = false;
                        }
                    );
                }
            }
        }
    } // navigationItem
}
