import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: container;

    spacing: constant.paddingSmall;
    anchors.left: parent.left; anchors.right: parent.right;
    height: childrenRect.height;

    Label {
        id: drawerLink;
        anchors { left: parent.left; right: parent.right; leftMargin: constant.paddingSmall; rightMargin: constant.paddingSmall; }
        font.pixelSize: constant.fontSizeXSmall;
        color: constant.colorHighlight;
        wrapMode: Text.Wrap;
        elide: Text.ElideRight;
        text: link;
    }
    Separator {
        id: drawerSep;
        anchors { left: parent.left; right: parent.right; }
        color: constant.colorSecondary;
    }

    BackgroundItem {
        id: browserItem;
        anchors.left: parent.left; anchors.right: parent.right;

        Label {
            id: drawerBrowser;
            anchors { left: parent.left; right: parent.right; }
            anchors.verticalCenter: parent.verticalCenter;
            font.pixelSize: constant.fontSizeXSmall;
            text: qsTr("Open link in browser");
            color: browserItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
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
            font.pixelSize: constant.fontSizeXSmall;
            text: qsTr("Copy link to clipboard");
            color: clipboardItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
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
}
