import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/storage.js" as Storage
import "../components/utils.js" as Utils;

Page {
    id: uploadedPage;
    allowedOrientations: Orientation.All;

    ListModel {
        id: uploadedModel;

        /*
        // Album props
        property string title : "";
        property string description : "";
        property string datetime;
        property string link : "";
        property string deletehash : "";
        */
    }

    signal load();

    onLoad: {
        var jsonObjects = Storage.readUploadedImageInfo();
        //console.log(JSON.stringify(jsonObjects));
        console.log("item=" + jsonObjects.length);

        for(var i=0; i<jsonObjects.length; i++) {
            var data = JSON.parse(jsonObjects[i]);
            if (data !== "") {
                //console.log("data=" + JSON.stringify(data));
                var imageData = {
                    id: data.id,
                    title: data.title,
                    description: data.description,
                    datetime: data.datetime,
                    link: Utils.replaceURLWithHTMLLinks(data.link),
                    deletehash: data.deletehash
                };

                uploadedModel.append(imageData);
            }
        }
    }

    SilicaFlickable {
        id: flickable;
        pressDelay: 0;
        z: -2;

        PageHeader { id: header; title: qsTr("Uploaded images"); }

        anchors.fill: parent;

        SilicaListView {
            id: listView;
            pressDelay: 0;

            model: uploadedModel;

            anchors { top: header.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; }
            anchors.leftMargin: constant.paddingMedium;
            anchors.rightMargin: constant.paddingMedium;

            delegate: Column {
                id: uploadedItem

                width: listView.width
                spacing: constant.paddingSmall

                Label {
                    id: titleLbl
                    width: parent.width
                    font.pixelSize: constant.fontSizeSmall
                    textFormat: Text.PlainText
                    wrapMode: Text.Wrap;
                    text: title
                }
                Label {
                    id: linkLbl
                    width: parent.width
                    font.pixelSize: constants.fontSizeSmall
                    textFormat: Text.StyledText;
                    linkColor: Theme.highlightColor;
                    truncationMode: TruncationMode.Fade;
                    wrapMode: Text.Wrap;
                    onLinkActivated: Qt.openUrlExternally(link);
                    text: link
                }

                Row {
                    width: parent.width

                    Label {
                        id: datetimeLbl
                        font.pixelSize: constant.fontSizeXXSmall
                        color: constant.colorHighlight
                        textFormat: Text.PlainText
                        text: datetime
                    }
                }
            }

            VerticalScrollDecorator { flickable: listView; }

        } // ListView
    }

    Component.onCompleted: {

    }

}
