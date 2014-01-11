import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: galleryDelegate;

    width: albumListView.width;
    height: galleryContent.height;

    ListItem {
        id: galleryContent;
        width: parent.width;
        contentHeight: imageColumn.height + 2 * Theme.paddingMedium;

        Column {
            id: imageColumn;
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; }
            height: childrenRect.height;
            spacing: Theme.paddingSmall;

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
                        //console.log("ready=" + AnimatedImage.Ready + "; frames=" + image.frameCount +"; playing=" + image.playing + "; paused=" + image.paused);
                        /*
                        console.log("id=" + id
                                    + "; title=" + title
                                    + "; desc="  + description
                                    + "; link=" + link
                                    + "; animated=" + animated
                                    + "; width=" + width
                                    + "; height=" + height
                                    + "; size=" + size
                                    + "; views=" + views
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
                }

                PinchArea {
                    anchors.fill: parent;
                    pinch.target: parent;
                    pinch.minimumScale: 1;
                    pinch.maximumScale: 4;
                }
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
            /*
            Image {
                id: stopIcon;
                source: "../images/icons/stop.svg";
                visible: animated && !playIcon.visible;
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        //image.playing = false;
                        image.paused = true;
                        playIcon.visible = true;
                        stopIcon.visible = false;
                    }
                }
            }
            */

            Label {
                id: imageDescText;
                wrapMode: Text.Wrap;
                textFormat: Text.RichText;
                text: description;
                font.pixelSize: Theme.fontSizeExtraSmall;
                anchors { left: parent.left; right: parent.right; }
                visible: (description) ? true : false;
            }
        }
    }
}
