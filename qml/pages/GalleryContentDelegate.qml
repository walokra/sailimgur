import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: galleryDelegate;

    property Item contextMenu;
    property bool menuOpen: contextMenu != null && contextMenu.parent === galleryDelegate;
    property string contextLink;
    property bool savingInProgress: false;

    width: albumListView.width;
    height: menuOpen ? contextMenu.height + galleryContent.height : galleryContent.height;

    ListItem {
        id: galleryContent;
        width: parent.width;
        contentHeight: galleryContainer.height + 2 * constant.paddingMedium;
        //clip: true;

        MouseArea {
            enabled: drawer.open;
            anchors.fill: galleryContainer;
            onClicked: {
                drawer.open = false;
            }
        }

        Column {
            id: galleryContainer;
            anchors.left: parent.left; anchors.right: parent.right;
            height: childrenRect.height;

            Drawer {
                id: drawer;

                anchors.left: parent.left; anchors.right: parent.right;
                dock: page.isPortrait ? Dock.Top : Dock.Left;
                height: imageColumn.height;

                background: Item {
                    id: drawerContextMenu;
                    anchors.left: parent.left; anchors.right: parent.right;
                    height: childrenRect.height;

                    ImageButtons {
                        id: imageButtons;
                    }
                }

                foreground: Column {
                    id: imageColumn;
                    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; }
                    height: (image.status != AnimatedImage.Ready) ? loadingImageIndicator.height + 2 * constant.paddingMedium : imageTitleText.height  + image.height;
                    spacing: constant.paddingSmall;

                    enabled: !drawer.opened;

                    Label {
                        id: imageTitleText;
                        wrapMode: Text.Wrap;
                        text: title;
                        font.pixelSize: constant.fontSizeXSmall;
                        color: constant.colorHighlight;
                        anchors { left: parent.left; right: parent.right; }
                        visible: (title && is_album) ? true : false;
                    }

                    AnimatedImage {
                        id: image;
                        anchors { left: parent.left; right: parent.right; }
                        asynchronous: true;

                        fillMode: Image.PreserveAspectFit;
                        source: (deviceOrientation === Orientation.Landscape || deviceOrientation === Orientation.LandscapeInverted) ? link_original : link;
                        width: parent.width;
                        playing: settings.autoplayAnim;
                        paused: false;
                        onStatusChanged: playing;
                        smooth: false;

                        MouseArea {
                            property int start_x;
                            property int start_y;

                            anchors.fill: parent;
                            onClicked: {
                                //console.log("ready=" + AnimatedImage.Ready + "; frames=" + image.frameCount +";
                                //playing=" + image.playing + "; paused=" + image.paused);
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
                                imageColumn.height = (imageColumn.height < drawerContextMenu.height) ? drawerContextMenu.height : imageColumn.height;
                                drawer.open = true;
                            }

                            onPressed: {
                                start_x = mouseX;
                                start_y = mouseY;
                            }

                            onPositionChanged: {
                                var x_diff = mouseX - start_x;
                                var y_diff = mouseY - start_y;

                                var abs_x_diff = Math.abs(x_diff);
                                var abs_y_diff = Math.abs(y_diff);

                                if (abs_x_diff != abs_y_diff) {
                                    if (abs_x_diff > abs_y_diff) {
                                        if (abs_x_diff > 50) {
                                            if (x_diff > 0) {
                                                if (prevEnabled) { galleryNavigation.previous(); }
                                            } else if (x_diff < 0) {
                                                galleryNavigation.next();
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        PinchArea {
                            anchors.fill: parent;
                            pinch.target: parent;
                            pinch.minimumScale: 1;
                            pinch.maximumScale: 4;
                        }

                        BusyIndicator {
                            id: loadingImageIndicator;
                            anchors.horizontalCenter: parent.horizontalCenter;
                            running: image.status != AnimatedImage.Ready || savingInProgress;
                            size: BusyIndicatorSize.Medium;
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

                }
            } // Drawer

            Label {
                id: imageDescText;
                wrapMode: Text.Wrap;
                text: description;
                font.pixelSize: constant.fontSizeXSmall;
                anchors { left: parent.left; right: parent.right; }
                visible: (description) ? true : false;
                elide: Text.ElideRight;
                textFormat: Text.StyledText;
                linkColor: Theme.highlightColor;
                onLinkActivated: {
                    //console.log("Link clicked! " + link);
                    contextLink = link;
                    contextMenu = commentContextMenu.createObject(galleryContent);
                    contextMenu.show(galleryDelegate);
                }
            }
        }
    } // galleryContent

    Component {
        id: commentContextMenu;

        ImageContextMenu {
            url: contextLink;
        }
    }
}
