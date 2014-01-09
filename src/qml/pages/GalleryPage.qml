import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: galleryPage;

    property string albumTitle: "";

    property string account_url;
    property string views;
    property string ups;
    property string downs;
    property string score;
    property string images_count;
    property int upsPercent;
    property int downsPercent;

    property bool prevEnabled: currentIndex > 0 || page > 0;

    ListModel {
        id: albumImagesModel;
    }

    ListModel {
        id: commentsModel;
    }

    signal load();

    onLoad: {
        loadingRect.visible = true;
        //console.log("galleryPage.onLoad: total=" + galleryModel.count + ", currentIndex=" + currentIndex);
        albumTitle = galleryModel.get(currentIndex).title;
        if (galleryModel.get(currentIndex).is_album) {
            Imgur.getAlbum(galleryModel.get(currentIndex).id);
        } else {
            Imgur.getGalleryImage(galleryModel.get(currentIndex).id);
        }
        //Imgur.getAlbumComments(galleryModel.get(currentIndex).id);
        setPrevButton();
    }

    function setPrevButton() {
        if (currentIndex === 0 && page === 0) {
            prevEnabled = false;
        } else {
            prevEnabled = true;
        }
    }

    SilicaFlickable {
        id: galleryFlickable;

        PageHeader {
            id: header;
            title: "Sailimgur";
        }

        /*
        PullDownMenu {
            id: pullDownMenu

            MenuItem {

            }
        }
        */

        /*
        PushUpMenu {
            id: pushUpMenu;

            MenuItem {
                text: qsTr("To top");
                onClicked: albumListView.scrollToTop();
            }
        }
        */

        anchors.fill: parent;
        contentHeight: contentArea.height;

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            height: childrenRect.height;

            anchors.leftMargin: Theme.paddingMedium;
            anchors.rightMargin: Theme.paddingMedium;

            Column {
                id: galleryColumn;
                anchors { left: parent.left; right: parent.right; }
                height: childrenRect.height + Theme.paddingMedium;
                spacing: Theme.paddingSmall;

                ListItem {
                    id: navigationItem;
                    anchors { left: parent.left; right: parent.right; }
                    height: prev.height;

                    Label {
                        id: prev;
                        text: qsTr("« Previous");
                        font.pixelSize: Theme.fontSizeSmall;

                        anchors.left: parent.left;

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                //console.log("Previous clicked! curr=" + currentIndex + "; page=" + page);
                                if (currentIndex > 0 && page >= 0) {
                                    currentIndex -= 1;
                                    load();
                                } else if (currentIndex === 0 && page >= 1) {
                                    //console.log("Getting previous list of images");
                                    page -= 1;
                                    currentIndex = -1;
                                    Imgur.processGalleryMode(true);
                                }
                                setPrevButton();
                            }
                        }
                        enabled: prevEnabled;
                        visible: prevEnabled;
                    }

                    Label {
                        id: next;
                        text: qsTr("Next »");
                        font.pixelSize: Theme.fontSizeSmall;

                        anchors.right: parent.right;

                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                //console.log("Next clicked! curr=" + currentIndex + "; model=" + galleryModel.count);
                                if (currentIndex < galleryModel.count-1) {
                                    //console.log("Getting next image");
                                    currentIndex += 1;
                                    load();
                                }
                                prevEnabled = true;
                                if (currentIndex === galleryModel.count-1) {
                                    //console.log("Getting new list of images");
                                    page += 1;
                                    currentIndex = 0;
                                    Imgur.processGalleryMode(true);
                                }
                            }
                        }
                    }
                } // navigationItem

                Label {
                    id: titleText;
                    anchors { left: parent.left; right: parent.right; }
                    wrapMode: Text.Wrap;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    text: albumTitle;
                }

                Flow {
                    id: albumListView;
                    anchors { left: parent.left; right: parent.right; }
                    height: childrenRect.height;
                    spacing: Theme.paddingSmall;

                    Repeater {
                        model: albumImagesModel;

                        Column {
                            id: imageColumn;
                            height: childrenRect.height;
                            width: albumListView.width;

                            ListItem {
                                width: parent.width;
                                height: image.height;

                                AnimatedImage {
                                    id: image;
                                    anchors { left: parent.left; top: parent.top; }

                                    fillMode: Image.PreserveAspectFit;
                                    source: link;
                                    width: parent.width;
                                    playing: settings.autoplayAnim;
                                    paused: false;
                                    onStatusChanged: playing;
                                    smooth: false;
                                    MouseArea{
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
                            }

                            Label {
                                id: imageTitleText;
                                wrapMode: Text.Wrap;
                                text: title;
                                font.pixelSize: Theme.fontSizeExtraSmall;
                                anchors { left: parent.left; right: parent.right; }
                            }
                            Label {
                                id: imageDescText;
                                wrapMode: Text.Wrap;
                                textFormat: Text.RichText;
                                text: description;
                                font.pixelSize: Theme.fontSizeExtraSmall;
                                anchors { left: parent.left; right: parent.right; }
                            }
                        } // imageColumn
                    } // Repeater
                } // Flow
            } // galleryColumn

            Column {
                id: albumInfoColumn;
                anchors { left: parent.left; right: parent.right; }
                height: 300;
                spacing: Theme.paddingSmall;

                ListItem {
                    id: albumInfo;
                    anchors { left: parent.left; right: parent.right; }

                    ListItem {
                        id: actionAndPointsItem;
                        anchors { left: parent.left; right: parent.right; }

                        ListItem {
                            id: actionButtons;
                            anchors { left: parent.left;}
                            anchors.verticalCenter: parent.verticalCenter;
                            width: 3 * 62 + 3 * Theme.paddingLarge;
                            height: 62;

                            IconButton {
                                id: likeButton;
                                icon.source: "../images/icons/like.svg";
                                onClicked: console.log("Like!");
                                enabled: false;
                                width: 62;
                                height: 62;
                                anchors { left: parent.left; }
                            }
                            IconButton {
                                id: dislikeButton;
                                icon.source: "../images/icons/dislike.svg";
                                onClicked: console.log("Dislike!");
                                enabled: false;
                                width: 62;
                                height: 62;
                                anchors { left: likeButton.right;
                                    leftMargin: Theme.paddingLarge; }
                            }
                            IconButton {
                                id: favoriteButton;
                                icon.source: "../images/icons/favorite.svg";
                                onClicked: console.log("Hearth!");
                                enabled: false;
                                width: 62;
                                height: 62;
                                anchors { left: dislikeButton.right;
                                    leftMargin: Theme.paddingLarge; rightMargin: Theme.paddingLarge; }
                            }
                        }

                        ListItem {
                            id: pointColumn;
                            width: 100;
                            anchors { top: parent.top; left: actionButtons.right; right: parent.right; }

                            Label {
                                id: scoreText;
                                anchors { left: parent.left; }
                                anchors.verticalCenter: parent.verticalCenter;
                                font.pixelSize: Theme.fontSizeExtraSmall;
                                text: score + " points";
                            }

                            Rectangle {
                                id: scoreUps;
                                anchors { left: scoreText.right; leftMargin: Theme.paddingLarge; }
                                anchors.verticalCenter: parent.verticalCenter;
                                width: 100 * (upsPercent/100);
                                height: 10;
                                color: "green";
                            }

                            Rectangle {
                                id: scoreDowns;
                                anchors { left: scoreUps.right; }
                                anchors.verticalCenter: parent.verticalCenter;
                                width: 100 * (downsPercent/100);
                                height: 10;
                                color: "red";
                            }
                        }
                    }

                    Column {
                        id: infoColumn;
                        anchors { top: actionAndPointsItem.bottom; left: parent.left; right: parent.right; }
                        height: childrenRect.height;

                        Label {
                            id: infoText;
                            anchors { left: parent.left; right: parent.right; }
                            wrapMode: Text.Wrap;
                            font.pixelSize: Theme.fontSizeExtraSmall;
                            text: "by " + account_url + ", " + views + " views";
                        }
                   }
                }
            } // albumInfoColumn

            /*
            Column {
                id: commentsColumn;
                anchors { left: parent.left; right: parent.right; }
                height: childrenRect.height;

                SilicaListView {
                    id: commentListView
                    //snapMode: ListView.SnapOneItem
                    //orientation: ListView.HorizontalFlick;
                    //highlightRangeMode: ListView.StrictlyEnforceRange
                    //cacheBuffer: width;
                    model: commentsModel;
                    height: childrenRect.height;

                    delegate: Item {
                        id: commentListArea;
                        anchors { left: parent.left; right: parent.right; }
                        height: commentText.height + authorText.height + 2 * Theme.paddingSmall;

                        Label {
                            id: commentText;
                            wrapMode: Text.Wrap;
                            text: comment;
                            textFormat: Text.RichText;
                            font.pixelSize: Theme.fontSizeExtraSmall;
                            onLinkActivated: {
                                console.log("Link clicked!");
                                basicHapticEffect.play();
                            }
                        }
                        Label {
                            id: authorText;
                            anchors { top: commentText.bottom; left: commentText.right; }
                            wrapMode: Text.Wrap;
                            text: author;
                            font.pixelSize: Theme.fontSizeExtraSmall
                        }
                    }
                }
            } // commentsColumn
            */
        } // Column

        ScrollDecorator { }
    } // SilicaFlickable

}