import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: container;

    spacing: Theme.paddingSmall;
    anchors.left: parent.left; anchors.right: parent.right;
    height: childrenRect.height;

    Label {
        id: drawerLink;
        anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall; }
        font.pixelSize: Theme.fontSizeExtraSmall;
        color: Theme.highlightColor;
        wrapMode: Text.Wrap;
        elide: Text.ElideRight;
        text: link;
    }
    Separator {
        id: drawerSep;
        anchors { left: parent.left; right: parent.right; }
        color: Theme.secondaryColor;
    }

    BackgroundItem {
        id: browserItem;
        anchors.left: parent.left; anchors.right: parent.right;

        Label {
            id: drawerBrowser;
            anchors { left: parent.left; right: parent.right; }
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: Theme.fontSizeExtraSmall;
            text: qsTr("Open link in browser");
            color: browserItem.highlighted ? Theme.highlightColor : Theme.primaryColor;
        }

        onClicked: {
            Qt.openUrlExternally(link);
            infoBanner.showText(qsTr("Launching browser."));
        }
    }

    BackgroundItem {
        id: clipboardItem;
        anchors.left: parent.left; anchors.right: parent.right;

        Label {
            id: drawerClipboard;
            anchors { left: parent.left; right: parent.right; }
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: Theme.fontSizeExtraSmall;
            text: qsTr("Copy link to clipboard");
            color: clipboardItem.highlighted ? Theme.highlightColor : Theme.primaryColor;
        }

        onClicked: {
            textArea.text = link; textArea.selectAll(); textArea.copy();
            infoBanner.showText(qsTr("Link " + textArea.text + " copied to clipboard."));
        }
    }

    BackgroundItem {
        id: imageInfoItem;
        anchors.left: parent.left; anchors.right: parent.right;

        Label {
            id: drawerImageInfo;
            anchors { left: parent.left; right: parent.right; }
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: Theme.fontSizeExtraSmall;
            text: qsTr("Show image info");
            color: imageInfoItem.highlighted ? Theme.highlightColor : Theme.primaryColor;
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
}
