import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: root;
    allowedOrientations: Orientation.All;

    Connections {
        target: settings;
        onSettingsLoaded: {
            if (settings.installedVersion === "" || settings.installedVersion !== APP_VERSION) {
                settings.installedVersion = APP_VERSION;
                settings.saveSetting("installedVersion", settings.installedVersion);
                pageStack.push(Qt.resolvedUrl("ChangelogDialog.qml"));
            }

            galleryModel.clear();
            signInPage.refreshDone = false;
            loadingRect.visible = false;

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
        target: settingsDialog;
        onToolbarPositionChanged: {
            galgrid.state = "reanchored";
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
                    signInPage.refreshDone = true;
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
        pressDelay: 0;
        z: -2;

        anchors.fill: parent;
        contentHeight: parent.height; contentWidth: parent.width;

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
                    pageStack.push(settingsDialog);
                }
            }
        }

        SilicaGridView {
            id: galgrid;

            cellWidth: (deviceOrientation === Orientation.Landscape || deviceOrientation === Orientation.LandscapeInverted) ? width / 5 : width / 3;
            cellHeight: cellWidth;
            clip: true;
            pressDelay: 0;

            model: galleryModel;

            anchors { left: parent.left; right: parent.right; }
            //anchors.top: (settings.toolbarBottom) ? parent.top : (actionBar.visible ? actionBar.bottom : parent.top);
            //anchors.bottom: (settings.toolbarBottom) ? (actionBar.visible ? actionBar.top : parent.bottom) : parent.bottom;

            transitions: Transition {
                // smoothly reanchor galgrid and move into new position
                AnchorAnimation { duration: 500 }
            }

            delegate: Loader {
                sourceComponent: GalleryDelegate { id: galleryDelegate; }
            }

            VerticalScrollDecorator { flickable: galgrid; }

            Rectangle {
                anchors { top: parent.top; left: parent.left; right: parent.right; margins: Theme.paddingLarge; }
                color: Theme.highlightBackgroundColor;
                visible: (galleryModel.busy) ? 1 : 0;

                Label {
                    id: statusLabel;
                    anchors { left: parent.left; right: parent.right; centerIn: parent; }
                    text: "Loading...";
                    color: constant.colorHighlight;
                }
            }

            // Load next/previous page when at the end or at the top
            onMovementEnded: {
                if (atYBeginning) {
                    actionBar.shown = true;
                }

                if(atYEnd) {
                    page += 1;
                    //console.log("atYEnd: " + page);
                    statusLabel.text = qsTr("Loading next page");
                    galleryModel.nextPage(galleryModel.query, true);
                }
            }

            states:
                State {
                    name: "reanchored"

                    AnchorChanges {
                        target: actionBar;
                        anchors.top: (settings.toolbarBottom) ? undefined : parent.top;
                        anchors.bottom: (settings.toolbarBottom) ? parent.bottom : undefined;
                    }

                    AnchorChanges {
                        target: galgrid;
                        anchors.top: (settings.toolbarBottom) ? parent.top : (actionBar.visible ? actionBar.bottom : parent.top);
                        anchors.bottom: (settings.toolbarBottom) ? (actionBar.visible ? actionBar.top : parent.bottom) : parent.bottom;
                    }
                }
        } // SilicaGridView

        ActionBar {
            id: actionBar;
            flickable: galgrid;
        }
    }

    Component.onCompleted: {
        galgrid.state = "reanchored";
        galleryModel.clear();
    }

}
