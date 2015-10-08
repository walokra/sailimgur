import QtQuick 2.0
import Sailfish.Silica 1.0

Component {
    BackgroundItem {
        id: root;
        anchors { left: parent.left; right: parent.right; }

        height: image.height;

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
                id: pinchArea

                property real minScale: 1.0
                property real maxScale: 3.0

                anchors.fill: parent
                enabled: image.status === Image.Ready
                pinch.target: image
                pinch.minimumScale: minScale * 0.5 // This is to create "bounce back effect"
                pinch.maximumScale: maxScale * 1.5 // when over zoomed

                onPinchFinished: {
                    if (image.scale < pinchArea.minScale) {
                        bounceBackAnimation.to = pinchArea.minScale
                        bounceBackAnimation.start()
                    }
                    else if (image.scale > pinchArea.maxScale) {
                        bounceBackAnimation.to = pinchArea.maxScale
                        bounceBackAnimation.start()
                    }
                }

                NumberAnimation {
                    id: bounceBackAnimation
                    target: image
                    duration: 250
                    property: "scale"
                    from: image.scale
                }
                // workaround to qt5.2 bug
                // otherwise pincharea is ignored
                Rectangle {
                    opacity: 0.0
                    anchors.fill: parent
                }
            }
        }

        BusyIndicator {
            id: loadingImageIndicator;
            anchors { centerIn: parent; }
            running: image.status != AnimatedImage.Ready || savingInProgress;
            size: BusyIndicatorSize.Medium;
        }

        IconButton {
            id: playIcon;
            anchors { centerIn: parent; }
            visible: animated && !image.playing;
            icon.width: Theme.itemSizeSmall;
            icon.height: Theme.itemSizeSmall;
            icon.source: constant.iconPlay;
            onClicked: internal.clickPlay();
        }

        onClicked: {
            internal.clickPlay();
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
            if (!isSlideshow) {
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

        QtObject {
            id: internal;

            function clickPlay() {
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
        }
    }
}
