import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: mainPage;

    property bool prevEnabled: page > 0;

    SilicaFlickable {
        id: flickable;

        PageHeader { id: header; title: settings.appName; }

        PullDownMenu {
            id: pullDownMenu;

            MenuItem {
                id: aboutMenu;
                text: qsTr("About");
                onClicked: {
                    pageStack.push(aboutPage);
                }
            }

            /*
            MenuItem {
                id: settingsMenu
                text: qsTr("Settings")
                onClicked: {
                    pageStack.push(settingsPage)
                }
            }

            MenuItem {
                id: signInMenu;
                text: qsTr("Sign In");
                onClicked: {
                    pageStack.push(signInPage);
                }
            }
            */

            MenuItem {
                id: refreshMenu;
                text: qsTr("Refresh");
                onClicked: {
                    Imgur.processGalleryMode(false, query);
                }
            }

            SearchField {
                id: searchTextField;

                width: parent.width;
                font.pixelSize: Theme.fontSizeSmall;
                font.bold: false;
                color: Theme.highlightColor;

                placeholderText: qsTr("Search...");
                placeholderColor: Theme.secondaryHighlightColor;

                EnterKey.enabled: text.trim().length > 0;
                //EnterKey.text: "Search!";

                Component.onCompleted: {
                    query = "";
                    _editor.accepted.connect(searchEntered);
                }

                // is called when user presses the Return key
                function searchEntered() {
                    query = text;
                    //console.log("Searched: " + query);
                    settings.galleryModeText = "Gallery results for \"" + query + "\"";
                    Imgur.getGallerySearch(query);
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
                        font.pixelSize: Theme.fontSizeSmall;

                        anchors.left: parent.left;
                        anchors.leftMargin: Theme.paddingMedium;

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                if (page > 0) {
                                    page -= 1;
                                }
                                //console.log("Previous clicked!: " + page);
                                Imgur.processGalleryMode(false, query);
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
                        font.pixelSize: Theme.fontSizeSmall;

                        anchors.right: parent.right;
                        anchors.rightMargin: Theme.paddingMedium;

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                page += 1;
                                //console.log("Next clicked!: " + page);
                                Imgur.processGalleryMode(false, query);
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

        Row {
            id: galleryMode;
            anchors { top: header.bottom; left: parent.left; right: parent.right; bottomMargin: Theme.paddingMedium; }
            width: mainPage.width;
            height: childrenRect.height;
            z: 1;

            ComboBox {
                id: modeBox;
                currentIndex: 0;
                width: 250;

                menu: ContextMenu {

                    MenuItem {
                        id: mainMode;
                        text: qsTr("most viral");
                        onClicked: {
                            sortBox.visible = true;
                            query = "";
                            searchTextField.text = "";
                            settings.mode = "main";
                            settings.section = "hot";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, query);
                        }
                    }

                    MenuItem {
                        id: userMode;
                        text: qsTr("user submitted");
                        onClicked: {
                            sortBox.visible = true;
                            query = "";
                            searchTextField.text = "";
                            settings.mode = "user";
                            settings.section = "user";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, query);
                        }
                    }

                    MenuItem {
                        id: randomMode;
                        text: qsTr("random");
                        onClicked: {
                            sortBox.visible = false;
                            query = "";
                            searchTextField.text = "";
                            settings.mode = "random";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, query);
                        }
                    }

                    MenuItem {
                        id: scoreMode;
                        text: qsTr("highest scoring");
                        onClicked: {
                            sortBox.visible = false;
                            query = "";
                            searchTextField.text = "";
                            settings.mode = "score";
                            settings.section = "top";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, query);
                        }
                    }

                    MenuItem {
                        id: memesMode;
                        text: qsTr("memes");
                        onClicked: {
                            sortBox.visible = true;
                            query = "";
                            searchTextField.text = "";
                            settings.mode = "memes";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, query);
                        }
                    }
                }
            }

            ComboBox {
                id: sortBox;
                currentIndex: 0;
                label: qsTr("sort:");

                menu: ContextMenu {
                    MenuItem {
                        id: viralSort;
                        text: qsTr("popularity");
                        onClicked: {
                            settings.sort = "viral";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, query);
                        }
                    }

                    MenuItem {
                        id: newestSort;
                        text: qsTr("newest first");
                        onClicked: {
                            settings.sort = "time";
                            galgrid.scrollToTop();
                            Imgur.processGalleryMode(false, query);
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
            anchors.leftMargin: Theme.paddingSmall;
            anchors.rightMargin: Theme.paddingSmall;

            delegate: Image {
                id: animatedImage;
                asynchronous: true;

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

            VerticalScrollDecorator {}
        } // SilicaGridView
    }

    Component.onCompleted: {
        //console.log("onCompleted");
        galleryModel.clear();
        Imgur.processGalleryMode(false, query);
    }

}
