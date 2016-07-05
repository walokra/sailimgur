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

        contentHeight: contentArea.height + 300;

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
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Show comments");
                checked: settings.showComments;
                onClicked: {
                    checked ? settings.showComments = true : settings.showComments = false;
                }
            }

            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                text: qsTr("Load comments automatically.");
            }

            Label {
                anchors { left:parent.left;}
                text: qsTr("Reddit Sub:");
                font.pixelSize: constant.fontSizeMedium;
            }

            TextField {
                id: redditSubInput;
                anchors { right: parent.right;}
                width: parent.width / 1.1;
                placeholderText: qsTr(settings.reddit_sub);
            }


            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Show mature content");
                checked: settings.showNsfw;
                onClicked: {
                    checked ? settings.showNsfw = true : settings.showNsfw = false;
                }
            }
            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                wrapMode: Text.Wrap;
                text: qsTr("Mature posts and comments may include sexually suggestive or adult-oriented content.");
            }

            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Autoplay videos / images");
                checked: settings.playImages;
                onClicked: {
                    checked ? settings.playImages = true : settings.playImages = false;
                }
            }
            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                wrapMode: Text.Wrap;
                text: qsTr("Autoplay animated images (gif/gifv). Disabling autoplay may help with showing large albums.");
            }

            /*
            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Show album images in own page");
                checked: settings.useGalleryPage;
                onClicked: {
                    checked ? settings.useGalleryPage = true : settings.useGalleryPage = false;
                }
            }
            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                wrapMode: Text.Wrap;
                text: qsTr("Open gallery album in own page. May help with showing large albums.");
            }
            */

            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Use video player");
                checked: settings.useVideoLoader;
                onClicked: {
                    checked ? settings.useVideoLoader = true : settings.useVideoLoader = false;
                }
            }
            Label {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                wrapMode: Text.Wrap;
                text: qsTr("Use video player to play gifv videos (mp4).");
            }

            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                text: qsTr("Hide toolbar when scrolling");
                checked: settings.toolbarHidden;
                onClicked: {
                    checked ? settings.toolbarHidden = true : settings.toolbarHidden = false;
                }
            }

            TextSwitch {
                anchors { left: parent.left; right: parent.right; }
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
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingExtraLarge;
                anchors.rightMargin: constant.paddingMedium;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall;
                text: qsTr("Might need to restart the app to work correctly.");
            }
        }

        VerticalScrollDecorator { flickable: settingsFlickable; }
    }

    onAccepted: {
        var oldRedditSub = settings.reddit_sub;

        // Upon change, and reddit mode activated -- reset gallery.
        if (oldRedditSub !== redditSubInput.text.trim()){
            console.log("differs");
            settings.reddit_sub = redditSubInput.text.trim();

            if (settings.mode === constant.mode_reddit){
                console.log("reddit mode");
                galleryModel.clear();
                galleryModel.processGalleryMode(galleryModel.query);
            }
        }
        settings.saveSettings();


    }

    Component.onCompleted: {
    }
}
