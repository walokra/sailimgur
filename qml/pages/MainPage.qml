import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: mp;
    allowedOrientations: Orientation.All;

    property string searchModeText : "";
    property alias contentItem: flickable;

    Connections {
        target: settings;
        onSettingsLoaded: {
            galleryModel.clear();
            signInPage.refreshDone = false;

            signInPage.init();
            if (settings.accessToken === "" || settings.refreshToken === "") {
                loggedIn = false;
                console.log("Not signed in. Using anonymous mode.");
                infoBanner.showText(qsTr("Not signed in. Using anonymous mode."));
                settings.user = qsTr("anonymous");
                galleryModel.processGalleryMode();
            } else {
                Imgur.getAccountCurrent(
                    internal.accountCurrentOnSuccess(),
                    internal.accountCurrentOnFailure()
                );
            }
        }
    }
    Connections {
        target: accountPanel;
        onClicked: {
            searchModeText = "";
            searchTextField.text = "";
        }
    }

    QtObject {
        id: internal;

        function accountCurrentOnSuccess() {
            return function(url) {
                loggedIn = true;
                settings.user = url;
                galleryModel.processGalleryMode();
            }
        }

        function accountCurrentOnFailure() {
            return function(status, statusText) {
                if (status === 403 && signInPage.refreshDone == false) {
                    signInPage.tryRefreshingTokens(
                        function() {
                            Imgur.getAccountCurrent(
                               internal.accountCurrentOnSuccess(),
                               internal.accountCurrentOnFailure()
                           );
                        }
                    );
                } else {
                    infoBanner.showHttpError(status, statusText);
                    loadingRect.visible = false;
                };
            }
        }
    }

    SilicaFlickable {
        id: flickable;
        //interactive: !galgrid.flicking;
        pressDelay: 0;
        z: -2;

        PageHeader { id: header; title: constant.appName; }

        PullDownMenu {
            id: pullDownMenu;

            MenuItem {
                id: aboutMenu;
                text: qsTr("About");
                onClicked: {
                    aboutPage.load();
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
                    searchModeText = "\"" + text + "\"";
                    galleryModel.clear();
                    galleryModel.processGalleryMode(searchTextField.text);
                    pullDownMenu.close();
                    searchTextField.focus = false;
                }
            }

        } // Pulldown menu

        anchors.fill: parent;

        GalleryMode { id: galleryMode; }

        SilicaGridView {
            id: galgrid;

            cellWidth: (deviceOrientation === Orientation.Landscape || deviceOrientation === Orientation.LandscapeInverted) ? width / 5 : width / 3;
            cellHeight: 175;
            clip: true;

            model: galleryModel;

            anchors { top: galleryMode.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; }
            anchors.leftMargin: constant.paddingMedium;
            anchors.rightMargin: constant.paddingMedium;

            delegate: Loader {
                sourceComponent: GalleryDelegate { id: galleryDelegate; }
            }

            VerticalScrollDecorator { flickable: galgrid; }

            // Timer for top/bottom buttons
            Timer {
                id: idle;
                property bool moving: galgrid.moving || galgrid.dragging || galgrid.flicking;
                //property bool menuOpen: pullDownMenu.active || pushUpMenu.active;
                property bool menuOpen: pullDownMenu.active;
                onMovingChanged: if (!moving && !menuOpen) restart();
                interval: galgrid.atYBeginning || galgrid.atYEnd ? 300 : 2000;
            }

            // to top button
            Rectangle {
                visible: opacity > 0;
                width: 64;
                height: 64;
                anchors { top: parent.top; right: parent.right; margins: Theme.paddingLarge; }
                radius: 75;
                color: Theme.highlightBackgroundColor;
                opacity: (idle.moving || idle.running) && !idle.menuOpen ? 1 : 0;
                Behavior on opacity { FadeAnimation { duration: 300; } }

                IconButton {
                    anchors.centerIn: parent;
                    icon.source: "image://theme/icon-l-up";
                    onClicked: {
                        galgrid.cancelFlick();
                        galgrid.scrollToTop();
                    }
                }
            }

            // to bottom button
            Rectangle {
                visible: opacity > 0;
                width: 64;
                height: 64;
                anchors { bottom: parent.bottom; right: parent.right; margins: Theme.paddingLarge; }
                radius: 75;
                color: Theme.highlightBackgroundColor;
                opacity: (idle.moving || idle.running) && !idle.menuOpen ? 1 : 0;
                Behavior on opacity { FadeAnimation { duration: 300; } }

                IconButton {
                    anchors.centerIn: parent;
                    icon.source: "image://theme/icon-l-down";
                    onClicked: {
                        galgrid.cancelFlick();
                        galgrid.scrollToBottom();
                    }
                }
            }

            Rectangle {
                anchors { top: parent.top; left: parent.left; right: parent.right; margins: Theme.paddingLarge; }
                color: Theme.highlightBackgroundColor;
                opacity: (galleryModel.loaded) ? 0 : 1;

                Label {
                    id: statusLabel;
                    anchors { left: parent.left; right: parent.right; centerIn: parent; }
                    text: "Loading...";
                    color: constant.colorHighlight;
                }
            }

            // Load next/previous page when at the end or at the top
            onMovementEnded: {
                if(atYBeginning) {
                    if (page > 0) {
                        page -= 1;
                        //console.log("atYBeginning: " + page);
                        statusLabel.text = qsTr("Loading previous page");
                        galleryModel.processGalleryMode(searchTextField.text);
                        galgrid.scrollToBottom();
                    }
                }
                if(atYEnd) {
                    page += 1;
                    //console.log("atYEnd: " + page);
                    statusLabel.text = qsTr("Loading next page");
                    galleryModel.processGalleryMode(searchTextField.text);
                    galgrid.scrollToTop();
                }
            }

        } // SilicaGridView
    }

    Component.onCompleted: {
        galleryModel.clear();
    }

}
