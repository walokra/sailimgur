import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Item {
    id: navBg;

    anchors {
        bottom: parent.bottom;
        bottomMargin: constant.paddingSmall
    }

    width: parent.width;
    height: constant.iconSizeMedium + constant.paddingSmall

    z: 2;

    visible: galleryModel.count > 1 || pageNo > 0;

    function previous() {
        //console.log("Previous clicked! curr=" + currentIndex + "; page=" + pageNo);
        if (currentIndex > 0 && pageNo >= 0) {
            currentIndex -= 1;
            load();
        }
        if (currentIndex === 0 && pageNo >= 1) {
            //console.log("Getting previous list of images");
            pageNo -= 1;

            loadingRect.visible = true;
            galleryModel.clear();
            currentIndex = -1;
            galleryModel.processGalleryMode(galleryModel.query);
        }
        setPrevButton();
    }

    function next() {
        //console.log("Next clicked! curr=", + currentIndex + "; count=" + galleryModel.count);
        if (currentIndex < galleryModel.count - 1) {
            //console.log("Getting next image");
            currentIndex += 1;
            load();
        }
        else if (currentIndex === galleryModel.count - 1) {
            //console.log("Getting new list of images");
            pageNo += 1;
            currentIndex = 0;

            loadingRect.visible = true;
            galleryModel.clear();
            galleryModel.processGalleryMode(galleryModel.query);
        }
        prevEnabled = true;
    }

    IconButton {
        id: prevButton;
        visible: prevEnabled;
        enabled: prevEnabled;
        icon.width: constant.iconSizeLarge;
        icon.height: icon.width;
        anchors { left: parent.left; leftMargin: constant.paddingMedium; }

        icon.source: constant.iconLeft;
        onClicked: {
            flickable.scrollToTop();
            previous();
        }
    }

    IconButton {
        id: nextButton;
        visible: is_gallery || (!is_gallery && currentIndex < galleryModel.count -1);
        icon.width: constant.iconSizeLarge;
        icon.height: icon.width;
        anchors { right: parent.right; rightMargin: constant.paddingMedium; }

        icon.source: constant.iconRight;
        onClicked: {
            flickable.scrollToTop();
            next();
        }
    }
}
