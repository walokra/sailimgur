import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: mainPage;

    property bool prevEnabled : page > 0;
    property string searchModeText : "";

    Connections {
        target: settings;
        onSettingsLoaded: {
            Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken);
            if (settings.accessToken === "" || settings.refreshToken === "") {
                loggedIn = false;
                console.log("Not signed in. Using anonymous mode.");
                infoBanner.showText(qsTr("Not signed in. Using anonymous mode."));
            } else {
                loggedIn = true;
            }
            Imgur.processGalleryMode(false, searchTextField.text);
        }
    }

    SilicaFlickable {
        id: flickable;

        PageHeader { id: header; title: constant.appName; }

        PullDownMenu {
            id: pullDownMenu;

            MenuItem {
                id: aboutMenu;
                text: qsTr("About");
                onClicked: {
                    pageStack.push(aboutPage);
                }
            }

            MenuItem {
                id: settingsMenu;
                text: qsTr("Settings");
                onClicked: {
                    pageStack.push(settingsPage);
                }
            }

            MenuItem {
                id: signInMenu;
                text: loggedIn ? qsTr("Logout") : qsTr("Sign In");
                onClicked: {
                    if (loggedIn === false) {
                        pageStack.push(signInPage);
                    } else {
                        settings.accessToken = "";
                        settings.refreshToken = "";
                        settings.saveTokens();
                        settings.settingsLoaded();
                    }
                }
            }

            SearchField {
                id: searchTextField;

                width: parent.width;
                font.pixelSize: constant.fontSizeSmall;
                font.bold: false;
                placeholderText: qsTr("Search...");

                EnterKey.enabled: text.trim().length > 0;
                EnterKey.iconSource: "image://theme/icon-m-enter-accept";
                EnterKey.onClicked: {
                    //console.log("Searched: " + query);
                    searchModeText = "Results for \"" + text + "\"";
                    galleryModel.clear();
                    Imgur.getGallerySearch(searchTextField.text);
                    pullDownMenu.close();
                    searchTextField.focus = false;
                }
            }

        } // Pulldown menu

        PushUpMenu {
            id: pushUpMenu;

            MenuItem {
                ListItem {
                    id: navigation;

                    Label {
                        id: prev;
                        text: qsTr("« Previous");
                        font.pixelSize: constant.fontSizeSmall;

                        anchors.left: parent.left;
                        anchors.leftMargin: constant.paddingMedium;

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                if (page > 0) {
                                    page -= 1;
                                }
                                //console.log("Previous clicked!: " + page);
                                Imgur.processGalleryMode(false, searchTextField.text);
                                if (page == 0) {
                                    prevEnabled = false;
                                }
                                pushUpMenu.close();
                                galgrid.scrollToTop();
                            }
                        }
                        enabled: prevEnabled;
                        visible: prevEnabled;
                    }

                    Label {
                        id: next;
                        text: qsTr("Next »");
                        font.pixelSize: constant.fontSizeSmall;

                        anchors.right: parent.right;
                        anchors.rightMargin: constant.paddingMedium;

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                page += 1;
                                //console.log("Next clicked!: " + page);
                                Imgur.processGalleryMode(false, searchTextField.text);
                                prevEnabled = true;
                                pushUpMenu.close();
                                galgrid.scrollToTop();
                            }
                        }
                    }
                } // ListItem
            }
        } // Pushup menu

        anchors.fill: parent;

        Label {
            id: searchModeLabel;
            width: mainPage.width / 2;
            anchors { top: header.bottom; left: parent.left; bottomMargin: constant.paddingMedium; }
            anchors.rightMargin: constant.paddingSmall;
            anchors.topMargin: constant.paddingMedium;

            text: searchModeText;
            font.pixelSize: constant.fontSizeMedium;
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
            visible: searchTextField.text.trim().length > 1;
        }

        Item {
            id: galleryMode;
            anchors { top: header.bottom; left: parent.left; right: parent.right; bottomMargin: constant.paddingMedium; }
            width: mainPage.width;
            height: childrenRect.height;
            z: 1;

            ComboBox {
                id: modeBox;
                currentIndex: 0;
                anchors.left: parent.left;
                width: mainPage.width / 2;
                visible: searchModeLabel.visible == false;

                menu: ContextMenu {

                    MenuItem {
                        id: mainMode;
                        text: qsTr("most viral");
                        onClicked: {
                            sortBox.visible = true;
                            searchTextField.text = "";
                            settings.mode = "main";
                            settings.section = "hot";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, "");
                        }
                    }

                    MenuItem {
                        id: userMode;
                        text: qsTr("user submitted");
                        onClicked: {
                            sortBox.visible = true;
                            searchTextField.text = "";
                            settings.mode = "user";
                            settings.section = "user";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, "");
                        }
                    }

                    MenuItem {
                        id: randomMode;
                        text: qsTr("random");
                        onClicked: {
                            sortBox.visible = false;
                            searchTextField.text = "";
                            settings.mode = "random";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, "");
                        }
                    }

                    MenuItem {
                        id: scoreMode;
                        text: qsTr("highest scoring");
                        onClicked: {
                            sortBox.visible = false;
                            searchTextField.text = "";
                            settings.mode = "score";
                            settings.section = "top";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, "");
                        }
                    }

                    MenuItem {
                        id: memesMode;
                        text: qsTr("memes");
                        onClicked: {
                            sortBox.visible = true;
                            searchTextField.text = "";
                            settings.mode = "memes";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, "");
                        }
                    }
                }
            }

            ComboBox {
                id: sortBox;
                width: mainPage.width / 2;
                anchors.right: parent.right;
                currentIndex: 0;
                label: qsTr("sort:");

                menu: ContextMenu {
                    MenuItem {
                        id: viralSort;
                        text: qsTr("popularity");
                        onClicked: {
                            settings.sort = "viral";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, searchTextField.text);
                        }
                    }

                    MenuItem {
                        id: newestSort;
                        text: qsTr("newest first");
                        onClicked: {
                            settings.sort = "time";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, searchTextField.text);
                        }
                    }
                }
            }
        } // galleryMode

        SilicaGridView {
            id: galgrid;

            cellWidth: width / 3;
            cellHeight: 175;
            clip: true;

            model: galleryModel;

            anchors { top: galleryMode.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; }
            anchors.leftMargin: constant.paddingSmall;
            anchors.rightMargin: constant.paddingSmall;

            delegate: Rectangle {
                border.color: (vote === "up") ? "green" : (vote === "down") ? "red" : "transparent";
                border.width: 3;
                width: 166;
                height: 166;

                Image {
                    id: image;
                    asynchronous: true;
                    anchors.centerIn: parent;

                    width: 160;
                    height: 160;

                    smooth: false;
                    source: link;
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            //console.log("galgrid: details for id=" + id + "; title=" + title + "; index=" + index);
                            currentIndex = index;
                            pageStack.push(galleryPage);
                            galleryPage.load();
                        }
                    }
                }
                }

            VerticalScrollDecorator {}
        } // SilicaGridView
    }

    Component.onCompleted: {
        galleryModel.clear();
    }

}
