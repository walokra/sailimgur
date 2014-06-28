import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Column {
    id: galleryContentLink;

    property string link : "";
    property string deletehash : "";
    property string title : "";

    anchors { left: parent.left; right: parent.right; }
    visible: is_gallery == false;

    ListItem {
        anchors { left: parent.left; right: parent.right; }

        ComboBox {
            id: linkBox;
            currentIndex: 0;
            width: parent.width / 3;
            anchors { left: parent.left; }
            contentHeight: linkItem.height;

            menu: ContextMenu {
                width: parent.width;

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
            width: parent.width * (2/3);
            anchors { left: linkBox.right; right: parent.right; }
            font.pixelSize: constant.fontSizeXSmall;
            text: link;
        }
    }

    ComboBox {
        id: actionBox;
        currentIndex: 0;
        width: parent.width;
        label: qsTr("Actions") + ": ";

        menu: ContextMenu {

            MenuItem {
                id: imageInfoAction;
                text: qsTr("image info");
                onClicked: {

                }
            }

            MenuItem {
                id: submitToGalleryAction;
                text: qsTr("submit to gallery");
                onClicked: {
                    Imgur.submitToGallery(imgur_id, title,
                        function(data){
                            console.log("Submitted to gallery. " + data);
                            infoBanner.showText(qsTr("Image submitted to gallery"));
                        },
                        function onFailure(status, statusText) {
                            infoBanner.showHttpError(status, statusText);
                        }
                    );
                }
            }

            MenuItem {
                id: deleteAction;
                text: qsTr("delete");
                onClicked: {
                    if (is_album) {
                        Imgur.albumDeletion(imgur_id,
                            function(data){
                                //console.log("Album deleted. " + data);
                                infoBanner.showText(qsTr("Album deleted"));
                            },
                            function onFailure(status, statusText) {
                                infoBanner.showHttpError(status, statusText);
                            }
                        );
                    } else {
                        Imgur.imageDeletion(imgur_id,
                            function(data){
                                //console.log("Image deleted. " + data);
                                infoBanner.showText(qsTr("Image deleted"));
                            },
                            function onFailure(status, statusText) {
                                infoBanner.showHttpError(status, statusText);
                            }
                        );
                    }
                }
            }
        }
    }
}
