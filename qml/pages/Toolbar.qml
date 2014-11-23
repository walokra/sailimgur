import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root;

    signal uploadClicked();

    property alias searchVisible: searchPanel.visible;

    anchors { left: parent.left; right: parent.right; }
    anchors.leftMargin: Theme.paddingSmall;
    anchors.rightMargin: Theme.paddingSmall;
    width: parent.width;
    height: actionList.height + constant.paddingMedium + (searchPanel.visible ? searchPanel.height : 0);

    ListItem {
        id: actionList;
        height: childrenRect.height + constant.paddingMedium;
        anchors.top: parent.top;
        anchors.topMargin: constant.paddingMedium;

        IconButton {
            id: logoButton;
            anchors { left: parent.left; }
            anchors.rightMargin: Theme.paddingMedium;
            //anchors.verticalCenter: parent.verticalCenter;
            icon.width: Theme.itemSizeSmall;
            icon.height: Theme.itemSizeSmall;
            icon.source: constant.iconLogo;
            opacity: 0.9;

            onClicked: {
                //console.debug("logo button clicked!");
                if (settings.mode === constant.mode_favorites
                        || settings.mode === constant.mode_albums
                        || settings.mode === constant.mode_images) {
                    settings.mode = constant.mode_main;
                    settings.saveSetting("mode", settings.mode);
                }

                searchPanel.visible = false;
                galgrid.scrollToTop();
                galleryModel.clear();
                galleryModel.processGalleryMode();
            }
        }

        /*
        Label {
            id: nameLabel;
            anchors { left: logoButton.right; }
            anchors.leftMargin: Theme.paddingMedium;
            anchors.verticalCenter: parent.verticalCenter;
            //width: parent.width / 2;
            text: "Sailimgur";
            font.pixelSize: constant.fontSizeMedium;
            color: constant.colorHighlight;
        }
        */

        IconButton {
            id: searchButton;
            anchors { right: accountButton.left; }
            anchors.rightMargin: Theme.paddingMedium;
            //anchors.verticalCenter: parent.verticalCenter;
            icon.width: Theme.itemSizeSmall;
            icon.height: Theme.itemSizeSmall;
            icon.source: constant.iconSearch;
            onClicked: {
                //console.debug("search button clicked!");
                if (searchPanel.visible === true) {
                    searchPanel.visible = false;
                } else {
                    searchPanel.visible = true;
                }
            }
        }

        IconButton {
            id: accountButton;
            anchors { right: uploadButton.left; }
            anchors.rightMargin: Theme.paddingMedium;
            anchors.verticalCenter: parent.verticalCenter;
            icon.width: Theme.itemSizeSmall;
            icon.height: Theme.itemSizeSmall;
            icon.source: constant.iconPerson;
            onClicked: {
                //console.debug("account button clicked!");
                if (loggedIn === false) {
                    pageStack.push(signInPage);
                } else {
                    pageStack.push(accountPage);
                    accountPage.load();
                }
            }
        }

        IconButton {
            id: uploadButton;
            anchors { right: parent.right; }
            anchors.verticalCenter: parent.verticalCenter;
            icon.width: Theme.itemSizeSmall;
            icon.height: Theme.itemSizeSmall;
            icon.source: constant.iconUpload;
            onClicked: {
                //console.debug("upload button clicked!")
                pageStack.push(uploadPage);
                uploadPage.load();
            }
        }
    }

    SearchPanel {
        id: searchPanel;
        anchors { top: actionList.bottom; left: parent.left; right: parent.right; }
        visible: false;
    }
}
