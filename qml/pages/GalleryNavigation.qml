import QtQuick 2.0
import Sailfish.Silica 1.0

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
                    currentIndex = -1;
                    Imgur.processGalleryMode(true, query);
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
                    Imgur.processGalleryMode(true, query);
                }
            }
        }
    } // navigationItem
}
