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

            ListItem {
                id: apiField;
                anchors { left: parent.left; right: parent.right }

                Label {
                    id: apiLabel;
                    text: qsTr("API key");
                    anchors { left: parent.left;}
                }
                TextField {
                    anchors { left: apiLabel.right; right: parent.right; }
                }
            }

        }

        ScrollDecorator {}
    }
}
