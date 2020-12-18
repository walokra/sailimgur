import QtQuick 2.0
import Sailfish.Silica 1.0

ContextMenu {
    id: contextMenu;
    property var url;

    Label {
        font.pixelSize: constant.fontSizeSmall;
        x: parent.x + Theme.paddingSmall;
        color: constant.colorHighlight;
        wrapMode: Text.Wrap;
        elide: Text.ElideRight;
        text: url;
    }

    Separator {
        anchors {
            left: parent.left;
            right: parent.right;
        }
        color: constant.colorSecondary;
    }

    MenuItem {
        anchors { left: parent.left; right: parent.right; }
        font.pixelSize: Screen.sizeCategory >= Screen.Large
                            ? constant.fontSizeSmall : constant.fontSizeXSmall;
        text: qsTr("Open link in browser");
        onClicked: {
            var props = {
                "url": url
            }
            pageStack.push(Qt.resolvedUrl("WebPage.qml"), props);
            //Qt.openUrlExternally(url);
            //infoBanner.showText(qsTr("Launching browser."));
        }
    }

    MenuItem {
        text: qsTr("Open in external browser");
        onClicked: {
            Qt.openUrlExternally(url);
        }
    }

    MenuItem {
        text: qsTr("Copy link to clipboard");
        onClicked: {
            Clipboard.text = url;
            infoBanner.showText(qsTr("Link " + Clipboard.text + " copied to clipboard."));
        }
    }
}
