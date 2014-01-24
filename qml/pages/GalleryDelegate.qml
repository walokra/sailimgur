import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: galleryDelegate;

    property Item contextMenu;
    property bool menuOpen: contextMenu != null && contextMenu.parent === galleryDelegate;
    property string url;

    width: albumListView.width;
    height: galleryContent.height;

    Drawer {
        id: drawer;

        anchors.fill: parent;
        dock: page.isPortrait ? Dock.Top : Dock.Left;

        background: Column {
            id: drawerContextMenu;
            anchors.fill: parent;
            spacing: Theme.paddingMedium;

            Label {
                id: drawerLink;
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall; }
                font.pixelSize: Theme.fontSizeExtraSmall;
                color: Theme.highlightColor;
                wrapMode: Text.Wrap;
                elide: Text.ElideRight;
                text: link;
            }
            Separator {
                id: drawerSep;
                anchors { left: parent.left; right: parent.right; }
                color: Theme.secondaryColor;
            }

            Label {
                id: drawerBrowser;
                anchors { left: parent.left; right: parent.right; }
                font.pixelSize: Theme.fontSizeExtraSmall;
                text: qsTr("Open link in browser");
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        Qt.openUrlExternally(link);
                        infoBanner.showText(qsTr("Launching browser."));
                    }
                }
            }

            Label {
                id: drawerClipboard;
                anchors { left: parent.left; right: parent.right; }
                anchors.topMargin: Theme.paddingExtraLarge;
                anchors.bottomMargin: Theme.paddingExtraLarge;
                font.pixelSize: Theme.fontSizeExtraSmall;
                text: qsTr("Copy link to clipboard");
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        textArea.text = link; textArea.selectAll(); textArea.copy();
                        infoBanner.showText(qsTr("Link " + textArea.text + " copied to clipboard."));
                    }
                }
            }

            Label {
                id: drawerImage;
                anchors { left: parent.left; right: parent.right; }
                font.pixelSize: Theme.fontSizeExtraSmall;
                text: qsTr("Show image info");
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        infoBanner.showText("id=" + id + " width=" + width + "; height=" + height
                                            + "; size=" + size + "; views=" + views + "; bandwidth=" + bandwidth);
                    }
                }
            }

            TextArea {
                id: textArea;
                visible: false;
            }
        }

        foreground: ListItem {
            id: galleryContent;
            width: parent.width;
            contentHeight: imageColumn.height + 2 * Theme.paddingMedium;
            clip: true;

            MouseArea {
                enabled: drawer.open;
                anchors.fill: imageColumn;
                onClicked: {
                    drawer.open = false;
                }
            }

            Column {
                id: imageColumn;
                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; }
                height: menuOpen ? contextMenu.height + childrenRect.height: childrenRect.height;
                spacing: Theme.paddingSmall;

                enabled: !drawer.opened;

                Label {
                    id: imageTitleText;
                    wrapMode: Text.Wrap;
                    text: title;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    anchors { left: parent.left; right: parent.right; }
                    visible: (title && is_album) ? true : false;
                }

                AnimatedImage {
                    id: image;
                    anchors { left: parent.left; right: parent.right; }
                    asynchronous: true;

                    fillMode: Image.PreserveAspectFit;
                    source: link;
                    width: parent.width;
                    playing: settings.autoplayAnim;
                    paused: false;
                    onStatusChanged: playing;
                    smooth: false;
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            //console.log("ready=" + AnimatedImage.Ready + "; frames=" + image.frameCount +";
                            //playing=" + image.playing + "; paused=" + image.paused);
                            /*
                        console.log("id=" + id
                                    + "; title=" + title + "; desc="  + description
                                    + "; link=" + link + "; animated=" + animated
                                    + "; width=" + width + "; height=" + height
                                    + "; size=" + size + "; views=" + views
                                    + "; bandwidth=" + bandwidth
                                    );
                        */
                            if (animated) {
                                if (!image.playing) {
                                    image.playing = true;
                                    image.paused = false;
                                    playIcon.visible = false;
                                }
                                if (image.paused) {
                                    image.paused = false;
                                    playIcon.visible = false;
                                } else {
                                    image.paused = true;
                                    playIcon.visible = true;
                                }
                                //console.log("playing=" + image.playing + "; paused=" + image.paused);
                            }
                        }
                        onPressAndHold: {
                            imageColumn.height = drawerContextMenu.height;
                            drawer.open = true;
                        }
                    }

                    PinchArea {
                        anchors.fill: parent;
                        pinch.target: parent;
                        pinch.minimumScale: 1;
                        pinch.maximumScale: 4;
                    }

                    Image {
                        anchors { centerIn: image; }
                        id: playIcon;
                        source: "../images/icons/play.svg";
                        visible: animated && !image.playing;
                        MouseArea{
                            anchors.fill: parent;
                            onClicked: {
                                if (animated) {
                                    if (!image.playing) {
                                        image.playing = true;
                                        image.paused = false;
                                        playIcon.visible = false;
                                    }
                                    if (image.paused) {
                                        image.paused = false;
                                        playIcon.visible = false;
                                    } else {
                                        image.paused = true;
                                        playIcon.visible = true;
                                    }
                                }
                            }
                        }
                    }
                }

                Label {
                    id: imageDescText;
                    wrapMode: (drawer.open) ? Text.NoWrap : Text.Wrap;
                    textFormat: Text.RichText;
                    text: description;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    anchors { left: parent.left; right: parent.right; }
                    width: parent.width;
                    visible: (description && !drawer.open) ? true : false;
                    elide: Text.ElideRight;
                    onLinkActivated: {
                        //console.log("Link clicked! " + link);
                        url = link;
                        contextMenu = commentContextMenu.createObject(galleryContent);
                        contextMenu.show(galleryDelegate);
                    }
                }
            }
        }
    } // Drawer

    Component {
        id: commentContextMenu;

        ContextMenu {
            Label {
                id: linkLabel;
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall; }
                font.pixelSize: Theme.fontSizeExtraSmall;
                color: Theme.highlightColor;
                wrapMode: Text.Wrap;
                elide: Text.ElideRight;
                text: url;
            }
            Separator {
                anchors { left: parent.left; right: parent.right; }
                color: Theme.secondaryColor;
            }

            MenuItem {
                anchors { left: parent.left; right: parent.right; }
                font.pixelSize: Theme.fontSizeExtraSmall;
                text: qsTr("Open link in browser");
                onClicked: {
                    Qt.openUrlExternally(url);
                    infoBanner.showText(qsTr("Launching browser."));
                }
            }
            MenuItem {
                anchors { left: parent.left; right: parent.right; }
                font.pixelSize: Theme.fontSizeExtraSmall;
                text: qsTr("Copy link to clipboard");
                onClicked: {
                    textArea.text = url; textArea.selectAll(); textArea.copy();
                    infoBanner.showText(qsTr("Link " + textArea.text + " copied to clipboard."));
                }
            }

            TextArea {
                id: textArea;
                visible: false;
            }
        }
    }
}
