import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: aboutPage;
    allowedOrientations: Orientation.All;

    signal load;

    Connections {
        target: settings;
        onSettingsLoaded: {
            Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);
        }
    }

    SilicaFlickable {
        id: aboutFlickable;

        anchors.fill: parent;
        contentHeight: contentArea.height + 2 * constant.paddingLarge;

        PageHeader {
            id: header;
            title: qsTr("About Sailimgur");
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            height: childrenRect.height;

            anchors.leftMargin: constant.paddingMedium;
            anchors.rightMargin: constant.paddingMedium;

            //SectionHeader { text: qsTr("About Sailimgur") }

            Item {
                anchors { left: parent.left; right: parent.right; }
                height: aboutText.height;

                Label {
                    id: aboutText;
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: constant.fontSizeMedium;
                    text: qsTr("Sailimgur is a simple Imgur app for Sailfish OS, powered by Qt, QML and JavaScript. \
It has a simple, native and easy-to-use UI. Sailimgur is Open Source and licensed under GPL v3.")
                }
            }

            SectionHeader { text: qsTr("Version") }

            Item {
                anchors { left: parent.left; right: parent.right; }
                height: versionText.height;

                Label {
                    id: versionText;
                    width: parent.width;
                    font.pixelSize: constant.fontSizeMedium;
                    wrapMode: Text.Wrap;
                    text: APP_VERSION + "-" + APP_RELEASE;
                }
            }

            SectionHeader { text: qsTr("Developed By"); }

            ListItem {
                id: root;

                Image {
                    id: rotImage;
                    source: "../images/rot_tr_86x86.png";
                    width: 86;
                    height: 86;
                }
                Label {
                    anchors { left: rotImage.right; leftMargin: constant.paddingLarge;}
                    text: "Marko Wallin, @walokra"
                    font.pixelSize: constant.fontSizeLarge
                }
            }

            SectionHeader { text: qsTr("Powered By") }

            ListItem {
                Image {
                    id: imgurImage;
                    source: "../images/imgur-logo.svg";
                    width: 150;
                    height: 54;
                }
                Label {
                    anchors { left: imgurImage.right; leftMargin: constant.paddingLarge; }
                    text: "Imgur";
                    font.pixelSize: constant.fontSizeLarge;
                }
            }

            ListItem {
                Image {
                    id: qtImage;
                    source: "../images/qt_icon.png";
                    width: 80;
                    height: 80;
                }
                Label {
                    anchors { left: qtImage.right; leftMargin: constant.paddingLarge; }
                    text: "Qt + QML";
                    font.pixelSize: constant.fontSizeLarge;
                }
            }

            SectionHeader { text: qsTr("imgur API Rate limits") }

            Label {
                id: creditsText;
                width: parent.width;
                height: 100;
                wrapMode: Text.Wrap;
                font.pixelSize: constant.fontSizeXSmall;
                text: "Remaining: " + settings.user + " = " + main.creditsUserRemaining + ", client = " + main.creditsClientRemaining;
            }
        }
        ScrollDecorator {}
    }

    onLoad: {
        Imgur.getCredits(
            function(userRemaining, clientRemaining){
                creditsUserRemaining = userRemaining;
                creditsClientRemaining = clientRemaining;
            },
            function(status, statusText){
            }
        );
    }

}
