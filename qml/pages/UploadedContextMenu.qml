import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

ContextMenu {
    id: contextMenu;

    property string imgur_id;
    property string link;
    property string deletehash;

    MenuItem {
        anchors { left: parent.left; right: parent.right; }
        font.pixelSize: constant.fontSizeXSmall;
        text: qsTr("Open link in browser");
        onClicked: {
            var props = {
                "url": link
            }
            pageStack.push(Qt.resolvedUrl("WebPage.qml"), props);
            //Qt.openUrlExternally(url);
            //infoBanner.showText(qsTr("Launching browser."));
        }
    }
    MenuItem {
        anchors { left: parent.left; right: parent.right; }
        font.pixelSize: constant.fontSizeXSmall;
        text: qsTr("Copy link to clipboard");
        onClicked: {
            textArea.text = link; textArea.selectAll(); textArea.copy();
            infoBanner.showText(qsTr("Link " + textArea.text + " copied to clipboard."));
        }
    }
    MenuItem {
        anchors { left: parent.left; right: parent.right; }
        font.pixelSize: constant.fontSizeXSmall;
        text: qsTr("Copy delete link to clipboard");
        onClicked: {
            textArea.text = "http://imgur.com/delete/" + deletehash; textArea.selectAll(); textArea.copy();
            infoBanner.showText(qsTr("Delete link " + textArea.text + " copied to clipboard."));
        }
    }
    MenuItem {
        anchors { left: parent.left; right: parent.right; }
        font.pixelSize: constant.fontSizeXSmall;
        text: qsTr("Delete image");
        onClicked: {
            deleteImageAlbum(imgur_id, deletehash);
        }
    }

    TextArea {
        id: textArea;
        visible: false;
    }

    function deleteImageAlbum(imgur_id, deletehash) {
        remorse.execute(qsTr("Deleting image"), function() {
                Imgur.imageDeletion(deletehash,
                    function(data){
                        //console.log("Image deleted. " + data);
                        infoBanner.showText(qsTr("Image deleted"));
                        uploadedModel.removeItem(imgur_id);
                    },
                    function onFailure(status, statusText) {
                        infoBanner.showHttpError(status, statusText);
                        if (status === 404) {
                            uploadedModel.removeItem(imgur_id);
                        }
                    }
                );
        });
    }
    RemorsePopup { id: remorse; }
}
