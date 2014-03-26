import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    id: galleryContentLink;

    property string link : "";
    property string deletehash : "";

    anchors { left: parent.left; right: parent.right; }
    width: parent.width;
    anchors.leftMargin: constant.paddingMedium;
    anchors.rightMargin: constant.paddingMedium;
    visible: is_gallery == false;

    ComboBox {
        id: linkBox;
        currentIndex: 0;
        width: parent.width / 4;

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
        width: (parent.width / 4) * 3;
        font.pixelSize: constant.fontSizeXSmall;
        text: link;
    }
}
