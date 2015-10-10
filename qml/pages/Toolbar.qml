import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root;

    signal searchChanged();

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
            anchors.rightMargin: Screen.sizeCategory >= Screen.Large
                                                ? constant.paddingLarge : constant.paddingMedium;
            icon.width: constant.iconSizeLarge;
            icon.height: icon.width;
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

                page = 0;
                galleryModel.query = "";
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
            font.pixelSize: Screen.sizeCategory >= Screen.Large
                                ? constant.fontSizeLarge : constant.fontSizeMedium;
            color: constant.colorHighlight;
        }
        */

        IconButton {
            id: searchButton;
            anchors { right: accountButton.left; }
            anchors.rightMargin: Screen.sizeCategory >= Screen.Large
                                    ? constant.paddingExtraLarge : constant.paddingMedium;
            icon.width: constant.iconSizeLarge;
            icon.height: icon.width;
            icon.source: constant.iconSearch;
            onClicked: {
                //console.debug("search button clicked!");
                if (searchPanel.visible === true) {
                    searchPanel.visible = false;
                    searchChanged();
                } else {
                    searchPanel.visible = true;
                    searchChanged();
                }
            }
        }

        IconButton {
            id: accountButton;
            anchors { right: uploadButton.left; }
            anchors.rightMargin: Screen.sizeCategory >= Screen.Large
                                    ? constant.paddingExtraLarge : constant.paddingMedium;
            anchors.verticalCenter: parent.verticalCenter;
            icon.width: constant.iconSizeLarge;
            icon.height: icon.width;
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
            icon.width: constant.iconSizeLarge;
            icon.height: icon.width;
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
