import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage;

    SilicaFlickable {
        id: aboutFlickable;

        anchors.fill: parent;
        contentHeight: contentArea.height;

        PageHeader {
            id: header;
            title: qsTr("About Sailimgur");
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            height: childrenRect.height;

            anchors.leftMargin: Theme.paddingMedium;
            anchors.rightMargin: Theme.paddingMedium;

            //SectionHeader { text: qsTr("About Sailimgur") }

            Item {
                anchors { left: parent.left; right: parent.right; }
                height: aboutText.height;

                Label {
                    id: aboutText;
                    width: parent.width;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeMedium;
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
                        font.pixelSize: Theme.fontSizeMedium;
                        wrapMode: Text.Wrap;
                        text: APP_VERSION;
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
                    anchors { left: rotImage.right; leftMargin: Theme.paddingLarge;}
                    text: "Marko Wallin, @walokra"
                    font.pixelSize: Theme.fontSizeLarge
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
                    anchors { left: imgurImage.right; leftMargin: Theme.paddingLarge; }
                    text: "Imgur";
                    font.pixelSize: Theme.fontSizeLarge;
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
                    anchors { left: qtImage.right; leftMargin: Theme.paddingLarge; }
                    text: "Qt + QML";
                    font.pixelSize: Theme.fontSizeLarge;
                }
            }
        }
        ScrollDecorator {}
    }

}
