import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: galleryContentLink;

    property bool showLink: false;
    property string link : "";
    property string deletehash : "";

    anchors { left: parent.left; right: parent.right; }
    visible: showLink;
    height: childrenRect.height;

    ComboBox {
        id: linkBox;
        currentIndex: 0;
        width: parent.width;
        anchors { left: parent.left; right: parent.right; }
        contentHeight: linkItem.height;

        menu: ContextMenu {
            width: galleryContentLink.width;

            MenuItem {
                id: linkItem;
                text: qsTr("Link");
                onClicked: {
                    albumLink.text = link;
                }
            }

            MenuItem {
                id: delItem;
                text: qsTr("Deletion link");
                onClicked: {
                    albumLink.text = "http://imgur.com/delete/" + deletehash;
                }
            }
        }
    }

    TextField {
        id: albumLink;
        width: parent.width;
        anchors { left: parent.left; right: parent.right; }
        font.pixelSize: constant.fontSizeXSmall;
        text: link;
    }
}
