import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: galleryContentLink;

    property string link : "";
    property string deletehash : "";

    anchors { left: parent.left; right: parent.right; }
    visible: is_gallery == false;

    ComboBox {
        id: linkBox;
        currentIndex: 0;
        width: parent.width;
        contentHeight: linkItem.height;

        menu: ContextMenu {
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
        anchors.topMargin: constant.paddingLarge;
        width: parent.width;
        font.pixelSize: constant.fontSizeXSmall;
        text: link;
    }
}
