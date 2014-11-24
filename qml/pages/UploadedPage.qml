import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: uploadedPage;
    allowedOrientations: Orientation.All;

    signal load();
    signal removedFromModel(string imgur_id);

    UploadedModel {
        id: uploadedModel;
    }

    onLoad: {
        uploadedModel.loadUploadedItems();
    }

    onRemovedFromModel: {
        uploadedModel.removeItem(imgur_id);
    }

    SilicaFlickable {
        id: flickable;
        pressDelay: 0;
        z: -2;

        PageHeader { id: header; title: qsTr("Uploaded images"); }

        anchors.fill: parent;
        anchors.leftMargin: constant.paddingMedium;
        anchors.rightMargin: constant.paddingMedium;

        SilicaListView {
            id: listView;
            pressDelay: 0;

            model: uploadedModel;

            anchors { top: header.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; }

            delegate: Loader {
                id: uploadedItemsLoader;
                asynchronous: true;

                sourceComponent: UploadedDelegate {
                    id: uploadedDelegate;
                    width: listView.width;
                    show_item: true;
                    show_extra: true;
                    item_is_album: false;
                    item_title: title;
                    item_imgur_id: imgur_id;
                    item_link: link;
                    item_deletehash: deletehash;
                    item_datetime: datetime;
                    parent_item: listView;
                }
            }

            VerticalScrollDecorator { flickable: listView; }

        } // ListView
    }

    Component.onCompleted: {

    }

}
