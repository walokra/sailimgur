import QtQuick 2.1
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Component {

    BackgroundItem {
        id: root;
        anchors { left: parent.left; right: parent.right; }

        height: (video) ? video.height : 0;

        property int start_x;
        property int start_y;

        Connections {
            target: galleryContentPage;
            onGgpStatusChanged: {
                // When gallery page is changed, destroy video
                if (ggpStatus === PageStatus.Deactivating) {
                    mediaPlayer.stop();
                    video.destroy();
                }
            }
        }

        Connections {
            target: coverPage;
            onCoverStatusChanged: {
                // When cover is activated, pause video and vice versa
                if (coverStatus === PageStatus.Activating) {
                    mediaPlayer.pause();
                }
            }
        }

        Image {
            id: image;
            anchors { left: parent.left; right: parent.right; }
            asynchronous: true;

            fillMode: Image.PreserveAspectFit;
            source: (deviceOrientation === Orientation.Landscape || deviceOrientation === Orientation.LandscapeInverted) ? link_original : link;
            width: parent.width;
            visible: (mediaPlayer) ? mediaPlayer.playbackState == MediaPlayer.StoppedState : true;
        }

        VideoOutput {
            id: video;
            anchors { left: parent.left; right: parent.right; }
            width: parent.orientation === Orientation.Portrait ? Screen.width : Screen.height;
            fillMode: VideoOutput.PreserveAspectFit;

            source: MediaPlayer {
                id: mediaPlayer;
                source: mp4;
                autoPlay: settings.playImages;
                loops: (looping) ? Animation.Infinite : 1;
            }
        }

        BusyIndicator {
            id: loadingVideoIndicator;
            anchors { centerIn: parent; }
            running: (mediaPlayer) ? mediaPlayer.status === MediaPlayer.Loading : false;
            size: BusyIndicatorSize.Medium;
        }

        IconButton {
            id: playIcon;
            anchors { centerIn: parent; }
            visible: (mediaPlayer) ? mediaPlayer.playbackState == MediaPlayer.StoppedState || mediaPlayer.playbackState === MediaPlayer.PausedState : false;
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

        QtObject {
            id: internal;

            function clickPlay() {
                //console.debug("playbackState=" + mediaPlayer.playbackState + "; status=" + status);
                if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                    mediaPlayer.pause();
                } else if (mediaPlayer.playbackState === MediaPlayer.PausedState) {
                    mediaPlayer.play();
                } else if (mediaPlayer.playbackState === MediaPlayer.StoppedState) {
                    mediaPlayer.play();
                }
            }
        }
    }
}
