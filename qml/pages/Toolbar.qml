import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: root;

    signal searchChanged();
    signal uploadClicked();

    property alias searchVisible: searchPanel.visible;

    anchors {
        left: parent.left;
        right: parent.right;
        top: parent.top;
        margins: Theme.horizontalPageMargin;
    }

    spacing: Theme.paddingMedium;
    height: actionList.height + (searchVisible ? searchPanel.height : 0) + Theme.horizontalPageMargin;

    Item {
        id: actionList;

        anchors {
            left: parent.left
            right: parent.right
        }

        width: parent.width;
        height: leftRow.height > rightRow.height ? leftRow.height : rightRow.height;

        IconButton {
            id: leftRow;
            anchors { left: parent.left }

            icon.width: constant.iconSizeLarge;
            icon.height: icon.width;
            icon.source: constant.iconLogo;
            opacity: 0.9;

            onClicked: {
                settings.mode = constant.mode_main;
                settings.saveSetting("mode", settings.mode);
                modeChanged("main");

                page = 0;
                galleryModel.query = "";
                searchPanel.visible = false;
                galgrid.scrollToTop();
                galleryModel.clear();
                galleryModel.processGalleryMode();
            }
        }

        Row {
            id: rightRow;
            spacing: Theme.paddingMedium;
            anchors.right: parent.right;

            IconButton {
                icon.width: constant.iconSizeLarge;
                icon.height: icon.width;
                icon.source: constant.iconSearch;
                onClicked: {
                    if (searchPanel.visible) {
                        searchPanel.visible = false;
                        searchChanged();
                    } else {
                        searchPanel.visible = true;
                        searchChanged();
                    }
                }
            }

            IconButton {
                icon.width: constant.iconSizeLarge;
                icon.height: icon.width;
                icon.source: constant.iconPerson;
                onClicked: {
                    if (loggedIn === false) {
                        pageStack.push(signInPage);
                    } else {
                        pageStack.push(accountPage);
                        accountPage.load();
                    }
                }
            }

            IconButton {
                icon.width: constant.iconSizeLarge;
                icon.height: icon.width;
                icon.source: constant.iconUpload;
                onClicked: {
                    pageStack.push(uploadPage);
                    uploadPage.load();
                }
            }
        }
    }

    SearchPanel {
        id: searchPanel;
        width: parent.width;
        visible: false;
    }
}
