import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    id: root;
    anchors { left: parent.left; right: parent.right; }
    width: parent.width;
    height: childrenRect.height;

    Connections {
        target: mp;
        onModeChanged: {
            internal.setMode(mode);
        }
    }

    spacing: Theme.paddingSmall;

    Connections {
        target: settings;

        onSettingsLoaded: {
            switch (settings.mode) {
                case constant.mode_main:
                    modeBox.currentIndex = 0;
                    settings.section = "hot";
                    break;
                case constant.mode_user:
                    modeBox.currentIndex = 1;
                    settings.section = constant.mode_user;
                    break;
                case constant.mode_random:
                    modeBox.currentIndex = 2;
                    break;
                case constant.mode_score:
                    modeBox.currentIndex = 3;
                    settings.section = "top";
                    break;
                case constant.mode_memes:
                    modeBox.currentIndex = 4;
                    break;
                case constant.mode_reddit:
                    modeBox.currentIndex = 5;
                    break;
                default:
                    modeBox.currentIndex = 0;
            }

            switch (settings.sort) {
                case "viral":
                    sortBox.currentIndex = 0;
                    break;
                case "time":
                    sortBox.currentIndex = 1;
                    break;
                default:
                    sortBox.currentIndex = 0;
            }
        }
    }

    Label {
        id: accountModeLabel;
        width: parent.width;
        height: constant.itemSizeMedium;
        text:
            settings.mode === constant.mode_favorites ?
                qsTr("Your favorite images") : (
                    settings.mode === constant.mode_albums ? qsTr("Your albums") : (
                            settings.mode === constant.mode_images) ? qsTr("Your images") : ""
                    );
        font.pixelSize: Screen.sizeCategory >= Screen.Large
                            ? constant.fontSizeLarge : constant.fontSizeMedium
        color: constant.colorHighlight;
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
        visible: settings.mode === constant.mode_favorites || settings.mode === constant.mode_albums || settings.mode === constant.mode_images;
    }

    ComboBox {
        id: modeBox;
        currentIndex: 0;
        width: parent.width / 2;
        visible: accountModeLabel.visible == false && galleryModel.query === "";

        menu: ContextMenu {
            MenuItem {
                id: mainMode;
                text: qsTr("most viral");
                onClicked: {
                    internal.setMode("main");
                }
            }

            MenuItem {
                id: userMode;
                text: qsTr("user submitted");
                onClicked: {
                    internal.setMode("user");
                }
            }

            MenuItem {
                id: randomMode;
                text: qsTr("random");
                onClicked: {
                    internal.setMode("random");
                }
            }

            MenuItem {
                id: scoreMode;
                text: qsTr("highest scoring");
                onClicked: {
                    internal.setMode("top");
                }
            }

            MenuItem {
                id: memesMode;
                text: qsTr("memes");
                onClicked: {
                    internal.setMode("memes");
                }
            }

            MenuItem {
                id: redditMode;
                text: qsTr("reddit");
                onClicked: {
                    internal.setMode("reddit");
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

    ComboBox {
        id: windowBox;
        width: parent.width / 2;
        currentIndex: 0;
        label: qsTr("window:");
        visible: accountModeLabel.visible == false;

        menu: ContextMenu {
            MenuItem {
                id: dayWind;
                text: qsTr("day");
                onClicked: {
                    settings.window = "day";
                    internal.setWindowCommon();
                }
            }

            MenuItem {
                id: weekWind;
                text: qsTr("week");
                onClicked: {
                    settings.window = "week";
                    internal.setWindowCommon();
                }
            }

            MenuItem {
                id: monthWind;
                text: qsTr("month");
                onClicked: {
                    settings.window = "month";
                    internal.setWindowCommon();
                }
            }

            MenuItem {
                id: yearWind;
                text: qsTr("year");
                onClicked: {
                    settings.window = "year";
                    internal.setWindowCommon();
                }
            }

            MenuItem {
                id: allWind;
                text: qsTr("all");
                onClicked: {
                    settings.window = "all";
                    internal.setWindowCommon();
                }
            }
        }
    }




    QtObject {
        id: internal;

        function setMode(mode) {
            if (mode === "main") {
                modeBox.currentIndex = 0;
                sortBox.visible = true;
                settings.mode = constant.mode_main;
                settings.section = "hot";
            } else if (mode === "user") {
                modeBox.currentIndex = 1;
                sortBox.visible = true;
                settings.mode = constant.mode_user;
                settings.section = constant.mode_user;
            } else if (mode === "random") {
                modeBox.currentIndex = 2;
                sortBox.visible = false;
                settings.mode = constant.mode_random;
            } else if (mode === "top") {
                modeBox.currentIndex = 3;
                sortBox.visible = false;
                settings.mode = constant.mode_score;
                settings.section = "top";
            } else if (mode === "memes") {
                modeBox.currentIndex = 4;
                sortBox.visible = true;
                settings.mode = constant.mode_memes;
            } else if (mode === "reddit") {
                modeBox.currentIndex = 5;
                sortBox.visible = false;
                settings.sort = "time";
                settings.showViral = false;
                settings.showComments = false;
                settings.mode = constant.mode_reddit;
            } else {
                modeBox.currentIndex = 0;
                sortBox.visible = true;
                settings.mode = constant.mode_main;
                settings.section = "hot";
            }
            internal.setModeCommon();
        }

        function setModeCommon() {
            settings.saveSetting("mode", settings.mode);
            page = 0;
            galleryModel.query = "";
            toolbar.searchVisible = false;
            galgrid.scrollToTop();
            galleryModel.clear();
            galleryModel.processGalleryMode();
        }

        function setSortCommon() {
            settings.saveSetting("sort", settings.sort);
            galgrid.scrollToTop();
            galleryModel.clear();
            galleryModel.processGalleryMode(galleryModel.query);
        }

        function setWindowCommon() {
            settings.saveSetting("window", settings.window);
            galgrid.scrollToTop();
            galleryModel.clear();
            galleryModel.processGalleryMode(galleryModel.query);
        }
    }

}
