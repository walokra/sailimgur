import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    id: galleryMode;
    anchors { top: header.bottom; left: parent.left; right: parent.right; bottomMargin: constant.paddingMedium; }
    width: parent.width;
    height: childrenRect.height;
    z: 1;
    anchors.leftMargin: constant.paddingMedium;
    anchors.rightMargin: constant.paddingMedium;

    spacing: Theme.paddingSmall;

    Label {
        id: searchModeLabel;
        width: parent.width / 2;
        text: searchModeText;
        font.pixelSize: constant.fontSizeMedium;
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
        visible: searchTextField.text.trim().length > 1;
    }

    Label {
        id: accountModeLabel;
        width: parent.width;
        text:
            settings.mode === constant.mode_favorites ?
                qsTr("Your favorite images") : (
                    settings.mode === constant.mode_albums ? qsTr("Your albums") : (
                            settings.mode === constant.mode_images) ? qsTr("Your images") : ""
                    );
        font.pixelSize: constant.fontSizeMedium;
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
        visible: settings.mode === constant.mode_favorites || settings.mode === constant.mode_albums || settings.mode === constant.mode_images;
    }

    ComboBox {
        id: modeBox;
        currentIndex: 0;
        width: parent.width / 2;
        visible: searchModeLabel.visible == false && accountModeLabel.visible == false;

        menu: ContextMenu {

            MenuItem {
                id: mainMode;
                text: qsTr("most viral");
                onClicked: {
                    sortBox.visible = true;
                    searchTextField.text = "";
                    settings.mode = constant.mode_main;
                    settings.section = "hot";
                    galgrid.scrollToTop();
                    galleryModel.processGalleryMode();
                }
            }

            MenuItem {
                id: userMode;
                text: qsTr("user submitted");
                onClicked: {
                    sortBox.visible = true;
                    searchTextField.text = "";
                    settings.mode = constant.mode_user;
                    settings.section = constant.mode_user;
                    galgrid.scrollToTop();
                    galleryModel.processGalleryMode();
                }
            }

            MenuItem {
                id: randomMode;
                text: qsTr("random");
                onClicked: {
                    sortBox.visible = false;
                    searchTextField.text = "";
                    settings.mode = constant.mode_random;
                    galgrid.scrollToTop();
                    galleryModel.processGalleryMode();
                }
            }

            MenuItem {
                id: scoreMode;
                text: qsTr("highest scoring");
                onClicked: {
                    sortBox.visible = false;
                    searchTextField.text = "";
                    settings.mode = constant.mode_score;
                    settings.section = "top";
                    galgrid.scrollToTop();
                    galleryModel.processGalleryMode();
                }
            }

            MenuItem {
                id: memesMode;
                text: qsTr("memes");
                onClicked: {
                    sortBox.visible = true;
                    searchTextField.text = "";
                    settings.mode = constant.mode_memes;
                    galgrid.scrollToTop();
                    galleryModel.processGalleryMode();
                }
            }
        }
    }

    ComboBox {
        id: sortBox;
        width: parent.width / 2;
        currentIndex: 0;
        label: qsTr("sort:");
        visible: accountModeLabel.visible == false;

        menu: ContextMenu {
            MenuItem {
                id: viralSort;
                text: qsTr("popularity");
                onClicked: {
                    settings.sort = "viral";
                    galgrid.scrollToTop();
                    galleryModel.clear();
                    galleryModel.processGalleryMode(searchTextField.text);
                }
            }

            MenuItem {
                id: newestSort;
                text: qsTr("newest");
                onClicked: {
                    settings.sort = "time";
                    galgrid.scrollToTop();
                    galleryModel.processGalleryMode(searchTextField.text);
                }
            }
        }
    }

} // galleryMode
