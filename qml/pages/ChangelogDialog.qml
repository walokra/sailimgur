import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: root;
    allowedOrientations: Orientation.All;

    SilicaFlickable {
        id: flickable;

        anchors.fill: parent;
        contentHeight: contentArea.height + 300;

        DialogHeader {
            id: header;
            title: qsTr("Changelog");
            acceptText: qsTr("Close");
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right; }
            height: childrenRect.height;
            anchors.margins: Theme.paddingSmall;
            spacing: Theme.paddingSmall;

            SectionHeader { text: qsTr("Version") + " 0.8.3 (2015-10-24)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Fix issue with fetching more comments.");
            }

            SectionHeader { text: qsTr("Version") + " 0.8.2 (2015-10-10)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Fix zoom on image. Adjust UI elements for tablet.");
            }

            SectionHeader { text: qsTr("Version") + " 0.8.1 (2015-08-09)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Add 'previous images' to limit showed images and to fix issues with large albums.");
            }

            SectionHeader { text: qsTr("Version") + " 0.8.0 (2015-08-02)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Enable playing mp4 videos by default, enhancements regarding playing videos.");
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Added setting to filter mature content. Showing mature content is off by default, 'safe for work'.");
            }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("To open imgur link with app, paste link to search field.");
            }

            SectionHeader { text: qsTr("Version") + " 0.7.4 (2015-07-26)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("New pulley actions for gallery page: open in external browser, copy link.");
            }

            SectionHeader { text: qsTr("Version") + " 0.7.3 (2015-06-25)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Support for actions with TOHKBD keys. Navigation with arrow keys, backspace, M to load more, C to load comments, gallery mode changed with 1-5.");
            }
            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Revert to showing plain animated images instead of gifv videos which aren't yet supported by Sailfish OS.");
            }

            SectionHeader { text: qsTr("Version") + " 0.7.2 (2015-05-20)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Gifv videos still unplayable due missing decoders. To view them, open album with browser (pulldown menu).");
            }
            /*
            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Added support for gifv videos.");
            }
            */
            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Option for autoplaying gif.");
            }
            /*
            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Theme.fontSizeExtraSmall;
                text: qsTr("Option for showing album in own page if over certain user given limit.");
            }
            */
            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Fix Qt 5.2 WebView chokes on caches from older Qt versions.");
            }

            SectionHeader { text: qsTr("Version") + " 0.7.1 (2014-11-25)" }

            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Use toolbar instead of sidebar for functions.");
            }
            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Option to select toolbar position top/bottom.");
            }
            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Account page shows user info and pages.");
            }
            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Image info shown on page.");
            }

            SectionHeader { text: qsTr("Version") + " 0.6 (2014-11-16)" }


            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("Save image to Pictures.");
            }
            Label {
                width: parent.width;
                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                text: qsTr("User Interface adjustments: next/previous links, image and comment actions.");
            }
        }

        VerticalScrollDecorator { flickable: flickable; }
    }

    onRejected: {
    }

    onAccepted: {
        root.backNavigation = true;
    }
}
