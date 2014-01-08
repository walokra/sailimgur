import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage;

    anchors.fill: parent;

    CoverPlaceholder {
        icon.source: "../images/sailimgur-logo_150x108.svg";
    }

    Column {
        //anchors { left: parent.left; right: parent.right;}
        anchors.centerIn: parent;
        width: parent.width;
        height: childrenRect.height;

        Item { width: 1; height: Theme.paddingLarge }
        //Item { width: 1; height: Theme.paddingLarge }
        Image {
            id: image;
            anchors { left: parent.left; right: parent.right;}

            property int currentIndex: 0;
            height: 160;
            width: 160;
            source: (galleryModel.count > 0) ? galleryModel.get(currentIndex).link : "";
            fillMode: Image.PreserveAspectCrop;
        }
    }

    CoverActionList {
        id: coverAction;

        CoverAction {
            iconSource: "image://theme/icon-cover-previous";
            onTriggered: {
                console.log("CoverAction.previous: count=" + galleryModel.count + "; index=" + image.currentIndex);
                image.currentIndex = (image.currentIndex - 1) % galleryModel.count;
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next";
            onTriggered: {
                console.log("CoverAction.next: count=" + galleryModel.count + "; index=" + image.currentIndex);
                image.currentIndex = (image.currentIndex + 1) % galleryModel.count;
            }
        }
    }


}
