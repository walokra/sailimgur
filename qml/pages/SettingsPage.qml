import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: settingsPage;

    SilicaFlickable {
        id: settingsFlickable;

        PageHeader {
            id: header;
            title: qsTr("Settings");
        }

        anchors.fill: parent;
        contentHeight: contentArea.height;

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right }
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
                onCheckedChanged: {
                    checked ? settings.showComments = checked : settings.showComments = false;
                }
            }
        }

        ScrollDecorator {}
    }
}
