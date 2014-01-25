import QtQuick 2.0
import Sailfish.Silica 1.0

ContextMenu {
    id: contextMenu;
    property var url;

    Label {
        id: linkLabel;
        anchors { left: parent.left; right: parent.right;
            leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall; }
        font.pixelSize: Theme.fontSizeExtraSmall;
        color: Theme.highlightColor;
        wrapMode: Text.Wrap;
        elide: Text.ElideRight;
        text: url;
    }
    Separator {
        anchors { left: parent.left; right: parent.right; }
        color: Theme.secondaryColor;
    }

    MenuItem {
        anchors { left: parent.left; right: parent.right; }
        font.pixelSize: Theme.fontSizeExtraSmall;
        text: qsTr("Open link in browser");
        onClicked: {
            Qt.openUrlExternally(url);
            infoBanner.showText(qsTr("Launching browser."));
        }
    }
    MenuItem {
        anchors { left: parent.left; right: parent.right; }
        font.pixelSize: Theme.fontSizeExtraSmall;
        text: qsTr("Copy link to clipboard");
        onClicked: {
            textArea.text = url; textArea.selectAll(); textArea.copy();
            infoBanner.showText(qsTr("Link " + textArea.text + " copied to clipboard."));
        }
    }

    TextArea {
        id: textArea;
        visible: false;
    }
}
