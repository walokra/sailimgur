import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: root;

    allowedOrientations: Orientation.All;

    SilicaFlickable {
        id: flickable;

        anchors.fill: parent;

        contentHeight: contentArea.height;

        DialogHeader {
            id: header;
            title: qsTr("Changelog");
            acceptText: qsTr("Close changelog");
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right; }
            height: childrenRect.height;

            anchors.leftMargin: constant.paddingMedium;
            anchors.rightMargin: constant.paddingMedium;
            anchors.margins: Theme.paddingMedium;
            spacing: Theme.paddingMedium;

            SectionHeader { text: qsTr("Version") + " 0.6 (2014-09-01)" }

            Column {
                anchors { left: parent.left; right: parent.right; }
                width: parent.width;
                height: childrenRect.height;

                spacing: constant.paddingSmall;

                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeSmall;
                    text: qsTr("Save gallery mode and sort options.");
                }
                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeSmall;
                    text: qsTr("User Interface adjustments: next/previous links, comment actions.");
                }
                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeSmall;
                    text: qsTr("Changelog shows in first start after update.");
                }
            }

            SectionHeader { text: qsTr("Version") + " 0.5.0 (2014-07-04)" }

            Column {
                anchors { left: parent.left; right: parent.right; }
                width: parent.width;
                height: childrenRect.height;

                spacing: constant.paddingSmall;

                Label {
                    width: parent.width;
                    font.pixelSize: Theme.fontSizeSmall;
                    wrapMode: Text.Wrap;
                    text: qsTr("Upload feature added for logged in and anonymous user.");
                }
                Label {
                    width: parent.width;
                    font.pixelSize: Theme.fontSizeSmall;
                    wrapMode: Text.Wrap;
                    text: qsTr("Delete image/album from user's image/album view.");
                }
                Label {
                    width: parent.width;
                    font.pixelSize: Theme.fontSizeSmall;
                    wrapMode: Text.Wrap;
                    text: qsTr("Storing uploaded image's info to database.");
                }
                Label {
                    width: parent.width;
                    font.pixelSize: Theme.fontSizeSmall;
                    wrapMode: Text.Wrap;
                    text: qsTr("Listing uploaded images in page and open them in browser, copy link or delete.");
                }
            }
        }

        VerticalScrollDecorator { flickable: flickable; }
    }

    onRejected: {
        // Not needed as the value isn't read anywhere
        //settings.saveSetting("changelogShown", true);
    }

    onAccepted: {
        //settings.saveSetting("changelogShown", true);

        root.backNavigation = true;
    }
}
