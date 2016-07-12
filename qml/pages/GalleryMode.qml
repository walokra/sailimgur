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
            internal.setMode(settings.mode);

            switch (settings.sort) {
                case "viral":
                    sortBox.currentIndex = 0;
                    break;
                case "time":
                    sortBox.currentIndex = 1;
                    break;
                case "top":
                    sortBox.currentIndex = 2;
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
        visible: (settings.mode === constant.mode_favorites || settings.mode === constant.mode_albums || settings.mode === constant.mode_images);
    }

    ComboBox {
        id: modeBox;
        currentIndex: 0;
        width: (settings.sort !== "top" || settings.mode === constant.mode_score)
                ? parent.width / 2 : parent.width / 3;
        visible: (accountModeLabel.visible == false && galleryModel.query === "");

        menu: ContextMenu {
            MenuItem {
                id: mainMode;
                text: qsTr("most viral");
                onClicked: {
                    internal.setMode(constant.mode_main);
                }
            }

            MenuItem {
                id: userMode;
                text: qsTr("user submitted");
                onClicked: {
                    internal.setMode(constant.mode_user);
                }
            }

            MenuItem {
                id: randomMode;
                text: qsTr("random");
                onClicked: {
                    internal.setMode(constant.mode_random);
                }
            }

            MenuItem {
                id: scoreMode;
                text: qsTr("highest scoring");
                onClicked: {
                    internal.setMode(constant.mode_score);
                }
            }

            MenuItem {
                id: memesMode;
                text: qsTr("memes");
                onClicked: {
                    internal.setMode(constant.mode_memes);
                }
            }

            MenuItem {
                id: redditMode;
                text: qsTr("reddit");
                onClicked: {
                    internal.setMode(constant.mode_reddit);
                }
            }

        }
    }

    ComboBox {
        id: sortBox;
        width: (settings.sort !== "top" || settings.mode === constant.mode_score)
                ? parent.width / 2 : parent.width / 3;
        currentIndex: 0;
//        label: qsTr("sort:");
        visible: accountModeLabel.visible == false;

        menu: ContextMenu {
            MenuItem {
                id: viralSort;
                text: qsTr("popularity");
                visible: (settings.mode !== constant.mode_reddit)
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

            MenuItem {
                id: topSort;
                text: qsTr("top");
                visible: (settings.mode === constant.mode_score
                          || settings.mode === constant.mode_memes
                          || settings.mode === constant.mode_reddit)
                onClicked: {
                    settings.sort = "top";
                    internal.setSortCommon();
                }
            }
        }
    }

    ComboBox {
        id: windowBox;
        width: (settings.sort !== "top" || settings.mode === constant.mode_score)
                ? parent.width / 2 : parent.width / 3;
        currentIndex: 0;
//        label: qsTr("window:");
        visible: (accountModeLabel.visible == false &&
                  settings.sort === "top" &&
                  settings.mode !== constant.mode_random);

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
            if (mode === constant.mode_main) {
                modeBox.currentIndex = 0;
                sortBox.visible = true;
                sortBox.currentIndex = 0;
                // There's no top sort
                if (settings.sort === "top") {
                    settings.sort = "viral";
                }
                settings.mode = constant.mode_main;
                settings.section = "hot";
                settings.window = "day";
            } else if (mode === constant.mode_user) {
                modeBox.currentIndex = 1;
                sortBox.visible = true;
                settings.mode = constant.mode_user;
                settings.section = constant.mode_user;
                if (settings.sort === "top") {
                    settings.sort = "viral";
                }
                settings.window = "day";
            } else if (mode === constant.mode_random) {
                modeBox.currentIndex = 2;
                sortBox.visible = false;
                settings.mode = constant.mode_random;
            } else if (mode === constant.mode_score) {
                modeBox.currentIndex = 3;
                sortBox.visible = false;
                settings.mode = constant.mode_score;
                settings.section = "top";
                settings.sort = "top";
            } else if (mode === constant.mode_memes) {
                modeBox.currentIndex = 4;
                sortBox.currentIndex = 1;
                sortBox.visible = true;
                settings.sort = "time";
                windowBox.currentIndex = 1;
                settings.window = "week";
                settings.mode = constant.mode_memes;
            } else if (mode === constant.mode_reddit) {
                modeBox.currentIndex = 5;
                sortBox.visible = true;
                sortBox.currentIndex = 1;
                settings.sort = "time";
                windowBox.currentIndex = 1;
                settings.window = "week";
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
