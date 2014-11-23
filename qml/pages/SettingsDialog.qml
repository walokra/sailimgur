import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/storage.js" as Storage

Dialog {
    id: root;
    allowedOrientations: Orientation.All;

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
            width: parent.width
            height: childrenRect.height;

            Slider {
                value: settings.albumImagesLimit;
                minimumValue: 1;
                maximumValue: 10;
                stepSize: 1;
                width: parent.width;
                valueText: value;
                label: qsTr("Images shown in album");
                onValueChanged: {
                    settings.albumImagesLimit = value;
                }
            }

            TextSwitch {
                anchors {left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;

                text: qsTr("Show comments");
                checked: settings.showComments;
                onCheckedChanged: {
                    checked ? settings.showComments = true : settings.showComments = false;
                }
            }
        }

        VerticalScrollDecorator { flickable: settingsFlickable; }
    }

    onAccepted: {
        settings.saveSettings();
    }

    Component.onCompleted: {
    }
}
