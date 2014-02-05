import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/storage.js" as Storage

Dialog {
    id: settingsPage;

    SilicaFlickable {
        id: settingsFlickable;

        anchors.fill: parent;
        contentHeight: contentArea.height;

        DialogHeader {
            id: header;
            title: qsTr("Settings");
            acceptText: qsTr("Save");
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            width: settingsPage.width;
            height: childrenRect.height;

            anchors.leftMargin: Theme.paddingMedium;
            anchors.rightMargin: Theme.paddingMedium;

            Slider {
                value: settings.albumImagesLimit;
                minimumValue: 1;
                maximumValue: 30;
                stepSize: 1;
                width: parent.width;
                valueText: value;
                label: qsTr("Images shown in album");
                onValueChanged: {
                    settings.albumImagesLimit = value;
                }
            }

            TextSwitch {
                text: qsTr("Show comments");
                checked: settings.showComments;
                onCheckedChanged: {
                    checked ? settings.showComments = true : settings.showComments = false;
                }
            }
        }

        ScrollDecorator {}
    }

    onAccepted: {
        Storage.setSetting(Storage.db, "limit_album_images", settings.albumImagesLimit)
        Storage.setSetting(Storage.db, "show_comments", settings.showComments);
    }

    // Load values when app is started
    Component.onCompleted: {
        getSettings();
    }

    function getSettings() {
        Storage.db = Storage.connect();
        settings.albumImagesLimit = Storage.getSetting(Storage.db, "limit_album_images", settings.albumImagesLimit);
        settings.showComments = Storage.getSetting(Storage.db, "show_comments", settings.showComments);
    }
}
