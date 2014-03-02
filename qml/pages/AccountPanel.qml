import QtQuick 2.1
import Sailfish.Silica 1.0

Panel {
    id: panel;

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

            BackgroundItem {
                id: signInItem;
                anchors.left: parent.left; anchors.right: parent.right;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: loggedIn ? qsTr("Logout") : qsTr("Sign In");
                    font.pixelSize: constant.fontSizeMedium;
                    color: signInItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    if (loggedIn === false) {
                        pageStack.push(signInPage);
                    } else {
                        settings.resetTokens();
                        settings.settingsLoaded();
                    }
                }
            }

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

                }
            }

            BackgroundItem {
                id: galleryProfileItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("gallery profile");
                    font.pixelSize: constant.fontSizeMedium;
                    color: galleryProfileItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {

                }
            }

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
        }

        VerticalScrollDecorator { }
    }

    onClicked: {
        //viewer.hidePanel();
    }

}
