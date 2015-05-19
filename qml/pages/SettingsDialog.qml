import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/storage.js" as Storage

Dialog {
    id: root;
    allowedOrientations: Orientation.All;

    signal toolbarPositionChanged;

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
                onClicked: {
                    //console.log("onClicked=" + checked);
                    checked ? settings.showComments = true : settings.showComments = false;
                    //console.log("settings.showComments=" + settings.showComments);
                }
            }
            Label {
                anchors {left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: constant.fontSizeXSmall;
                text: qsTr("Load comments automatically.");
            }

            TextSwitch {
                anchors {left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Autoplay animated images (gif/gifv)");
                checked: settings.playImages;
                onClicked: {
                    checked ? settings.playImages = true : settings.playImages = false;
                }
            }
            Label {
                anchors {left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: constant.fontSizeXSmall;
                wrapMode: Text.Wrap;
                text: qsTr("Autoplay animated images (gif/gifv). Disabling autoplay may help with showing large albums.");
            }

            /*
            TextSwitch {
                anchors {left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Show album images in own page");
                checked: settings.useGalleryPage;
                onClicked: {
                    checked ? settings.useGalleryPage = true : settings.useGalleryPage = false;
                }
            }
            Label {
                anchors {left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: constant.fontSizeXSmall;
                wrapMode: Text.Wrap;
                text: qsTr("Open gallery album in own page. May help with showing large albums.");
            }
            */

            TextSwitch {
                anchors {left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Hide toolbar when scrolling");
                checked: settings.toolbarHidden;
                onClicked: {
                    checked ? settings.toolbarHidden = true : settings.toolbarHidden = false;
                }
            }

            TextSwitch {
                anchors {left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Toolbar on bottom");
                checked: settings.toolbarBottom;
                onClicked: {
                    checked ? settings.toolbarBottom = true : settings.toolbarBottom = false;
                    toolbarPositionChanged();
                }
            }
            Label {
                anchors {left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: constant.fontSizeXSmall;
                text: qsTr("Might need to restart the app to work correctly.");
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
