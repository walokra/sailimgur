import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    property var iconSize: Theme.itemSizeSmall;

    height: iconSize + 2 * Theme.paddingMedium;

    anchors {
        horizontalCenter: parent.horizontalCenter;
        bottomMargin: Theme.paddingMedium;
        topMargin: Theme.paddingMedium;
    }

    spacing: Theme.paddingLarge;

    Component.onCompleted: {
        sailimgurMgr.saveImageSucceeded.connect(internal.saveImageSucceeded);
        sailimgurMgr.errorImageExists.connect(internal.errorImageExists);
    }

    IconButton {
        id: dlIcon;
        icon.width: parent.iconSize;
        icon.height: parent.iconSize;
        icon.source: constant.iconSave;

        visible: !savingInProgress

        onClicked: {
            savingInProgress = true;
            if (type === "image/gif" && size && size.indexOf("MiB") > -1) {
                var sizeNo = size.replace(" MiB", "");
                if (parseInt(sizeNo) > settings.maxGifSize) {
                    sailimgurMgr.saveImage(mp4);
                } else {
                    sailimgurMgr.saveImage(link_original);
                }
            } else {
                sailimgurMgr.saveImage(link_original);
            }
        }
    }

    IconButton {
        icon.width: parent.iconSize;
        icon.height: parent.iconSize;
        icon.source: constant.iconSaving;

        visible: savingInProgress;
    }

    IconButton {
        icon.width: parent.iconSize;
        icon.height: parent.iconSize;
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
        icon.width: parent.iconSize;
        icon.height: parent.iconSize;
        icon.source: constant.iconClipboard;
        onClicked: {
            Clipboard.text = link_original;
            infoBanner.showText(qsTr("Image link " + Clipboard.text + " copied to clipboard."));
        }
    }

    IconButton {
        icon.width: parent.iconSize;
        icon.height: parent.iconSize;
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
            if (infoBanner) {
                infoBanner.showText("Image saved as " + name);
            }
            savingInProgress = false;
            dlIcon.icon.source = constant.iconSaveDone;
        }
        function errorImageExists(name) {
            if (infoBanner) {
                infoBanner.showText("Image already saved as " + name);
            }
            savingInProgress = false;
            dlIcon.icon.source = constant.iconSaveDone;
        }
    }

}
