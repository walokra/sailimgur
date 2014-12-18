import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Component {
    BackgroundItem {
        id: root;
        anchors { left: parent.left; right: parent.right; }

        height: video.height;

        property int start_x;
        property int start_y;

        MediaPlayer {
            id: mediaPlayer
            source: mp4
            autoPlay: true
            loops: (looping) ? Animation.Infinite : 1;
        }

        VideoOutput {
            id: video
            width: parent.width
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
