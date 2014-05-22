import QtQuick 2.0
import Sailfish.Silica 1.0

Panel {
    id: accountPanel;

    signal clicked();

    SilicaFlickable {
        pressDelay: 0;

        anchors.fill: parent;
        contentHeight: contentArea.height;

        Column {
            id: contentArea;
            width: parent.width;
            height: childrenRect.height;

            anchors { left: parent.left; right: parent.right; margins: Theme.paddingLarge; }
            spacing: constant.paddingLarge;

            Label {
                anchors { left: parent.left; right: parent.right; }
                text: settings.user;
                color: constant.colorHighlight;
                width: parent.width;
            }

            /*
            BackgroundItem {
                id: uploadImagesItem;
                anchors.left: parent.left; anchors.right: parent.right;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("upload images");
                    font.pixelSize: constant.fontSizeMedium;
                    color: uploadImagesItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    pageStack.push(uploadPage);
                }
            }
            */

            BackgroundItem {
                id: mainItem;
                anchors.left: parent.left; anchors.right: parent.right;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("main gallery");
                    font.pixelSize: constant.fontSizeMedium;
                    color: mainItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    settings.mode = constant.mode_main;

                    internal.setCommonValues();
                }
            }

            BackgroundItem {
                id: favoritesItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("favorites");
                    font.pixelSize: constant.fontSizeMedium;
                    color: favoritesItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    settings.mode = constant.mode_favorites;

                    internal.setCommonValues();
                }
            }

            BackgroundItem {
                id: albumsItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("albums");
                    font.pixelSize: constant.fontSizeMedium;
                    color: albumsItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    settings.mode = constant.mode_albums;

                    internal.setCommonValues();
                }
            }

            BackgroundItem {
                id: imagesItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("images");
                    font.pixelSize: constant.fontSizeMedium;
                    color: imagesItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    settings.mode = constant.mode_images;

                    internal.setCommonValues();
                }
            }

            /*
            BackgroundItem {
                id: messagesItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("messages");
                    font.pixelSize: constant.fontSizeMedium;
                    color: messagesItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {

                }
            }

            BackgroundItem {
                id: accountSettingsItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("account settings");
                    font.pixelSize: constant.fontSizeMedium;
                    color: accountSettingsItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {

                }
            }
            */

            BackgroundItem {
                id: signInItem;
                anchors.left: parent.left; anchors.right: parent.right;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: loggedIn ? qsTr("logout") : qsTr("sign in");
                    font.pixelSize: constant.fontSizeMedium;
                    color: signInItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    if (loggedIn === false) {
                        pageStack.push(signInPage);
                    } else {
                        loggedIn = false;
                        settings.resetTokens();
                        settings.settingsLoaded();
                    }
                }
            }
        }

        VerticalScrollDecorator { }
    }

    onClicked: {
        viewer.hidePanel();
    }

    QtObject {
        id: internal;

        function setCommonValues() {
            currentIndex = 0;
            page = 0;
            galleryModel.processGalleryMode();
            viewer.hidePanel();
            clicked();
        }
    }
}
