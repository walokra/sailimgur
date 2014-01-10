import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: mainPage;

    property bool prevEnabled: page > 0;
    property string query : "";

    SilicaFlickable {
        id: flickable;

        PageHeader { id: header; title: "Sailimgur"; }

        PullDownMenu {
            id: pullDownMenu;

            MenuItem {
                id: aboutMenu;
                text: qsTr("About");
                onClicked: {
                    //console.log("About clicked");
                    pageStack.push(aboutPage);
                }
            }

            /*
            MenuItem {
                id: settingsMenu
                text: qsTr("Settings")
                onClicked: {
                    console.log("Settings clicked");
                    pageStack.push(settingsPage)
                }
            }
            */

            MenuItem {
                id: refreshMenu;
                text: qsTr("Refresh");
                onClicked: {
                    //console.log("Refresh clicked");
                    Imgur.processGalleryMode(false);
                }
            }

            MenuItem {
                id: galleryModeMenu;

                ListItem {
                    width: mainPage.width;
                    anchors {left: parent.left; right: parent.right; }

                    Label {
                        id: galleryLabel;
                        text: qsTr("Gallery mode: ");
                        anchors {left: parent.left;}
                    }

                    Label {
                        id: mainLabel;
                        text: qsTr("Main");
                        anchors {left: galleryLabel.right; leftMargin: Theme.paddingMedium; }
                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                //console.log("Main gallery selected");
                                settings.mode = "main";
                                galgrid.scrollToTop();
                                Imgur.processGalleryMode(false);
                            }
                        }
                    }

                    Label {
                        id: separatorLabel;
                        text: qsTr("|");
                        anchors {left: mainLabel.right; leftMargin: Theme.paddingMedium; }
                    }

                    Label {
                        id: randomLabel;
                        text: qsTr("Random");
                        anchors {left: separatorLabel.right; leftMargin: Theme.paddingMedium; }
                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                //console.log("Random mode selected");
                                settings.mode = "random";
                                galgrid.scrollToTop();
                                Imgur.processGalleryMode(false);
                            }
                        }
                    }
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
                                Imgur.processGalleryMode(false);
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
                                Imgur.processGalleryMode(false);
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
        //contentHeight: mainArea.height;

        Label {
            id: galleryModeField;
            anchors { top: header.bottom; left: parent.left; right: parent.right; bottomMargin: Theme.paddingMedium; }
            anchors.leftMargin: Theme.paddingSmall;
            anchors.rightMargin: Theme.paddingSmall;

            width: parent.width;
            text: settings.galleryModeText;
            font.pixelSize: Theme.fontSizeExtraSmall;
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
        }

        SilicaGridView {
            id: galgrid;

            cellWidth: width / 3;
            cellHeight: 175;

            model: galleryModel;

            anchors { top: galleryModeField.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; }
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
        Imgur.processGalleryMode(false);
    }

}
