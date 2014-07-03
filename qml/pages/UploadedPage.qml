import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: uploadedPage;
    allowedOrientations: Orientation.All;

    signal load();

    UploadedModel {
        id: uploadedModel;
    }

    onLoad: {
        uploadedModel.loadUploadedItems();
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

            delegate: Loader {
                id: uploadedItemsLoader;
                asynchronous: true;

                sourceComponent: UploadedDelegate {
                    id: uploadedDelegate;
                    width: listView.width
                }
            }

            VerticalScrollDecorator { flickable: listView; }

        } // ListView
    }

    Component.onCompleted: {

    }

}
