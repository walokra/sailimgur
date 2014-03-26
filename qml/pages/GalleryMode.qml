import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    id: galleryMode;
    anchors { top: header.bottom; left: parent.left; right: parent.right; }
    width: parent.width;
    //height: childrenRect.height;
    z: 1;
    anchors.leftMargin: constant.paddingMedium;
    anchors.rightMargin: constant.paddingMedium;

    spacing: Theme.paddingSmall;

    Label {
        id: searchModeLabel;
        width: parent.width / 2;
        text: searchModeText;
        font.pixelSize: constant.fontSizeMedium;
        color: constant.colorHighlight;
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
        visible: searchModeText.trim().length > 1;
        anchors.verticalCenter: parent.verticalCenter;
    }

    Label {
        id: accountModeLabel;
        width: parent.width;
        height: Theme.itemSizeExtraSmall;
        text:
            settings.mode === constant.mode_favorites ?
                qsTr("Your favorite images") : (
                    settings.mode === constant.mode_albums ? qsTr("Your albums") : (
                            settings.mode === constant.mode_images) ? qsTr("Your images") : ""
                    );
        font.pixelSize: constant.fontSizeMedium;
        color: constant.colorHighlight;
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
                    settings.mode = constant.mode_main;
                    settings.section = "hot";

                    internal.setModeCommon();
                }
            }

            MenuItem {
                id: userMode;
                text: qsTr("user submitted");
                onClicked: {
                    sortBox.visible = true;
                    settings.mode = constant.mode_user;
                    settings.section = constant.mode_user;

                    internal.setModeCommon();
                }
            }

            MenuItem {
                id: randomMode;
                text: qsTr("random");
                onClicked: {
                    sortBox.visible = false;
                    settings.mode = constant.mode_random;

                    internal.setModeCommon();
                }
            }

            MenuItem {
                id: scoreMode;
                text: qsTr("highest scoring");
                onClicked: {
                    sortBox.visible = false;
                    settings.mode = constant.mode_score;
                    settings.section = "top";

                    internal.setModeCommon();
                }
            }

            MenuItem {
                id: memesMode;
                text: qsTr("memes");
                onClicked: {
                    sortBox.visible = true;
                    settings.mode = constant.mode_memes;

                    internal.setModeCommon();
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

                    internal.setSortCommon();
                }
            }

            MenuItem {
                id: newestSort;
                text: qsTr("newest");
                onClicked: {
                    settings.sort = "time";

                    internal.setSortCommon();
                }
            }
        }
    }

    QtObject {
        id: internal;

        function setModeCommon() {
            searchTextField.text = "";
            galgrid.scrollToTop();
            galleryModel.processGalleryMode();
        }

        function setSortCommon() {
            galgrid.scrollToTop();
            galleryModel.processGalleryMode(searchTextField.text);
        }
    }

}// galleryMode
