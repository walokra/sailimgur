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
            acceptText: qsTr("Close");
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right; }
            height: childrenRect.height;

            anchors.margins: Theme.paddingSmall;
            spacing: Theme.paddingSmall;

            SectionHeader { text: qsTr("Version") + " 0.7.2 (2015-05-20)" }

            Column {
                anchors { left: parent.left; right: parent.right; }
                width: parent.width;
                height: childrenRect.height;

                spacing: constant.paddingSmall;

                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("Gifv videos still unplayable due missing decoders. To view them, open album with browser (pulldown menu).");
                }
				
                /*
                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("Added support for gifv videos.");
                }
                */

                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("Option for autoplaying gif.");
                }

                /*
                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("Option for showing album in own page if over certain user given limit.");
                }
                */

                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("Fix Qt 5.2 WebView chokes on caches from older Qt versions.");
                }
            }

            SectionHeader { text: qsTr("Version") + " 0.7.1 (2014-11-25)" }

            Column {
                anchors { left: parent.left; right: parent.right; }
                width: parent.width;
                height: childrenRect.height;

                spacing: constant.paddingSmall;

                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("Use toolbar instead of sidebar for functions.");
                }
                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("Option to select toolbar position top/bottom.");
                }
                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("Account page shows user info and pages.");
                }
                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("Image info shown on page.");
                }
            }

            SectionHeader { text: qsTr("Version") + " 0.6 (2014-11-16)" }

            Column {
                anchors { left: parent.left; right: parent.right; }
                width: parent.width;
                height: childrenRect.height;

                spacing: constant.paddingSmall;

                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("Save image to Pictures.");
                }
                Label {
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: qsTr("User Interface adjustments: next/previous links, image and comment actions.");
                }
            }
        }

        VerticalScrollDecorator { flickable: flickable; }
    }

    onRejected: {
    }

    onAccepted: {
        root.backNavigation = true;
    }
}
