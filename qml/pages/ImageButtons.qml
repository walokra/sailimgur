import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: container;

    height: childrenRect.height + constant.paddingMedium;
    anchors.horizontalCenter: parent.horizontalCenter;

    Component.onCompleted: {
        sailimgurMgr.saveImageSucceeded.connect(internal.saveImageSucceeded);
        sailimgurMgr.errorImageExists.connect(internal.errorImageExists);
    }

    IconButton {
        id: saveButton;
        anchors { left: parent.left; }
        //anchors.horizontalCenter: parent.horizontalCenter;
        anchors.rightMargin: Theme.paddingLarge;
        icon.width: Theme.itemSizeExtraSmall;
        icon.height: Theme.itemSizeExtraSmall;
        icon.source: constant.iconSave;
        onClicked: {
            savingInProgress = true;
            sailimgurMgr.saveImage(image.source);
        }
    }

    IconButton {
        id: browserButton;
        anchors { left: saveButton.right; }
        //anchors.horizontalCenter: parent.horizontalCenter;
        anchors.leftMargin: Theme.paddingLarge;
        anchors.rightMargin: Theme.paddingLarge;
        icon.width: Theme.itemSizeExtraSmall;
        icon.height: Theme.itemSizeExtraSmall;
        icon.source: constant.iconBrowser;
        onClicked: {
            //Qt.openUrlExternally(link);
            //infoBanner.showText(qsTr("Launching browser."));
            var props = {
                "url": link_original
            }
            pageStack.push(Qt.resolvedUrl("WebPage.qml"), props);
        }
    }

    IconButton {
        id: clipboardButton;
        anchors { left: browserButton.right; }
        //anchors.horizontalCenter: parent.horizontalCenter;
        anchors.leftMargin: Theme.paddingLarge;
        anchors.rightMargin: Theme.paddingLarge;
        icon.width: Theme.itemSizeExtraSmall;
        icon.height: Theme.itemSizeExtraSmall;
        icon.source: constant.iconClipboard;
        onClicked: {
            Clipboard.text = link_original;
            infoBanner.showText(qsTr("Image link " + Clipboard.text + " copied to clipboard."));
        }
    }

    IconButton {
        id: infoButton;
        anchors { left: clipboardButton.right; }
        //anchors.horizontalCenter: parent.horizontalCenter;
        anchors.leftMargin: Theme.paddingLarge;
        anchors.rightMargin: Theme.paddingLarge;
        icon.width: Theme.itemSizeExtraSmall;
        icon.height: Theme.itemSizeExtraSmall;
        icon.source: constant.iconInfo;
        onClicked: {
            //console.debug(JSON.stringify(galleryContentModel));
            var props = {
                "image_id": id,
                "image_width": vWidth,
                "image_height": vHeight,
                "type": type,
                "size": size,
                "views": views,
                "bandwith": bandwidth,
                "section": section,
                "animated": animated,
                "nsfw": nsfw,
                "ups": ups,
                "downs": downs
            }

            pageStack.push(Qt.resolvedUrl("ImageInfoPage.qml"), props)
        }
    }

    QtObject {
        id: internal;

        function saveImageSucceeded(name) {
            //var msg = qsTr("Image saved as %1").arg(name);
            if (infoBanner) {
                infoBanner.showText("Image saved as " + name);
            }
            savingInProgress = false;
        }
        function errorImageExists(name) {
            //var msg = qsTr("Image already saved as %1").arg(name);
            if (infoBanner) {
                infoBanner.showText("Image already saved as " + name);
            }
            savingInProgress = false;
        }
    }

}
