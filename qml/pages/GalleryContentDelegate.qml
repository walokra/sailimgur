import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Item {
    id: galleryContentDelegate;

    property Item contextMenu;
    property bool menuOpen: contextMenu != null && contextMenu.parent === galleryContentDelegate;
    property string contextLink;
    property bool savingInProgress: false;

    width: albumListView.width;
    height: menuOpen ? contextMenu.height + galleryContent.height : galleryContent.height;

    Component.onCompleted: {
        //console.debug("type=" + type + "; mp4=" + mp4 +"; gifv=" + gifv + "; webm="+webm);
        //console.debug("vWidth=" + vWidth + "; vHeight="+vHeight)
        if (animated === false) {
            imageLoader.active = true;
        } else if (type === "image/gif" && mp4 !== "") {
            videoLoader.active = true;
        } else {
            imageLoader.active = true;
        }
    }

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
                backgroundSize: parent.width / 5;

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
                    height: imageTitleText.height + ((imageLoader.active) ? imageLoader.height : videoLoader.height);
                    //height: childrenRect.height;
                    spacing: constant.paddingSmall;

                    enabled: !drawer.opened;

                    Label {
                        id: imageTitleText;
                        anchors.leftMargin: constant.paddingSmall;
                        anchors.rightMargin: constant.paddingSmall;
                        wrapMode: Text.Wrap;
                        text: title;
                        font.pixelSize: constant.fontSizeXSmall;
                        color: constant.colorHighlight;
                        anchors { left: parent.left; right: parent.right; }
                        visible: (title && is_album) ? true : false;
                    }

                    Loader {
                        id: videoLoader;

                        width: Math.min(vWidth, parent.width);
                        height: (active) ? vHeight : 0;
                        anchors.horizontalCenter: parent.horizontalCenter;

                        active: false;
                        visible: active;
                        asynchronous: true;
                        sourceComponent: videoComponent;
                    }

                    Loader {
                        id: imageLoader;

                        width: Math.min(vWidth, parent.width);
                        height: (active) ? vHeight : 0;
                        anchors.horizontalCenter: parent.horizontalCenter;

                        active: false;
                        visible: active;
                        asynchronous: true;
                        sourceComponent: imageComponent;
                    }
                }
            } // Drawer

            Label {
                id: imageDescText;
                wrapMode: Text.Wrap;
                text: description;
                font.pixelSize: constant.fontSizeXSmall;
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingSmall;
                anchors.rightMargin: constant.paddingSmall;
                visible: (description) ? true : false;
                elide: Text.ElideRight;
                textFormat: Text.StyledText;
                linkColor: Theme.highlightColor;
                onLinkActivated: {
                    //console.log("Link clicked! " + link);
                    contextLink = link;
                    contextMenu = commentContextMenu.createObject(galleryContent);
                    contextMenu.show(galleryContentDelegate);
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

    Component {
        id: imageComponent

        BackgroundItem {
            id: imageItem
            anchors { left: parent.left; right: parent.right; }

            property int start_x;
            property int start_y;

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

                PinchArea {
                    anchors.fill: parent;
                    pinch.target: parent;
                    pinch.minimumScale: 1;
                    pinch.maximumScale: 4;
                }
            }

            BusyIndicator {
                id: loadingImageIndicator;
                anchors.horizontalCenter: parent.horizontalCenter;
                running: image.status != AnimatedImage.Ready || savingInProgress;
                size: BusyIndicatorSize.Medium;
            }

            Image {
                id: playIcon;
                anchors { centerIn: image; }
                visible: animated && !image.playing;
                width: Theme.itemSizeSmall;
                height: Theme.itemSizeSmall;
                source: constant.iconPlay;
            }

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
    }

    Component {
        id: videoComponent

        BackgroundItem {
            id: videoItem
            anchors { left: parent.left; right: parent.right; }

            property int start_x;
            property int start_y;

            MediaPlayer {
                id: mediaPlayer
                source: mp4
                autoPlay: true
            }

            VideoOutput {
                id: video
                width: parent.width
                height: parent.height
                source: mediaPlayer
                fillMode: VideoOutput.PreserveAspectFit
            }

            BusyIndicator {
                id: loadingVideoIndicator;
                anchors.horizontalCenter: parent.horizontalCenter;
                running: mediaPlayer.status === MediaPlayer.Loading;
                size: BusyIndicatorSize.Medium;
            }

            Image {
                id: playIcon;
                anchors { centerIn: video; }
                visible: false;
                width: Theme.itemSizeSmall;
                height: Theme.itemSizeSmall;
                source: constant.iconPlay;
            }

            onClicked: {
                //console.debug("playbackState=" + mediaPlayer.playbackState + "; status=" + status);
                if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    mediaPlayer.pause();
                    playIcon.visible = true;
                } else if (mediaPlayer.playbackState === MediaPlayer.PausedState) {
                    mediaPlayer.play();
                    playIcon.visible = false;
                } else if (mediaPlayer.playbackState === MediaPlayer.StoppedState) {
                    mediaPlayer.play();
                    playIcon.visible = false;
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
    }
}
