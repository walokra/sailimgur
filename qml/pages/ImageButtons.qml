import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: container;

    spacing: constant.paddingSmall;
    anchors.left: parent.left; anchors.right: parent.right;
    height: childrenRect.height;

    Component.onCompleted: {
        sailimgurMgr.saveImageSucceeded.connect(internal.saveImageSucceeded);
        sailimgurMgr.errorImageExists.connect(internal.errorImageExists);
    }

    /*
    Label {
        id: drawerLink;
        anchors { left: parent.left; right: parent.right; leftMargin: constant.paddingSmall; rightMargin: constant.paddingSmall; }
        font.pixelSize: constant.fontSizeXSmall;
        color: constant.colorHighlight;
        wrapMode: Text.Wrap;
        elide: Text.ElideRight;
        text: link_original;
    }
    Separator {
        id: drawerSep;
        anchors { left: parent.left; right: parent.right; }
        color: constant.colorSecondary;
    }
    */

    BackgroundItem {
        id: saveItem;
        anchors.left: parent.left; anchors.right: parent.right;

        Label {
            id: saveLbl;
            anchors { left: parent.left; right: parent.right; }
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: constant.fontSizeXSmall;
            text: qsTr("Save image");
            color: saveItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
        }

        onClicked: {
            savingInProgress = true;
            sailimgurMgr.saveImage(image.source);
        }
    }

    BackgroundItem {
        id: browserItem;
        anchors.left: parent.left; anchors.right: parent.right;

        Label {
            id: drawerBrowser;
            anchors { left: parent.left; right: parent.right; }
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: constant.fontSizeXSmall;
            text: qsTr("Open image in browser");
            color: browserItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
        }

        onClicked: {
            //Qt.openUrlExternally(link);
            //infoBanner.showText(qsTr("Launching browser."));
            var props = {
                "url": link_original
            }
            pageStack.push(Qt.resolvedUrl("WebPage.qml"), props);
        }
    }

    BackgroundItem {
        id: clipboardItem;
        anchors.left: parent.left; anchors.right: parent.right;

        Label {
            id: drawerClipboard;
            anchors { left: parent.left; right: parent.right; }
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: constant.fontSizeXSmall;
            text: qsTr("Copy link to clipboard");
            color: clipboardItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
        }

        onClicked: {
            textArea.text = link_original; textArea.selectAll(); textArea.copy();
            infoBanner.showText(qsTr("Image link " + textArea.text + " copied to clipboard."));
        }
    }

    BackgroundItem {
        id: imageInfoItem;
        anchors.left: parent.left; anchors.right: parent.right;

        Label {
            id: drawerImageInfo;
            anchors { left: parent.left; right: parent.right; }
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: constant.fontSizeXSmall;
            text: qsTr("Show image info");
            color: imageInfoItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
        }

        onClicked: {
            infoBanner.showText("id=" + id + " width=" + width + "; height=" + height
                + "; size=" + size + "; views=" + views + "; bandwidth=" + bandwidth);
        }
    }

    TextArea {
        id: textArea;
        visible: false;
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
