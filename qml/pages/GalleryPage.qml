import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: galleryPage;

    property string albumTitle : "";

    // Gallery props
    property string account_url : "";
    property string views : "0";
    property string ups : "0";
    property string downs : "0";
    property string score : "0";
    property string vote : "none";
    property bool favorite : false;
    property string images_count : "0";
    property int upsPercent : 0;
    property int downsPercent : 0;

    property bool is_album: false;
    property string imgur_id : "";

    property string galleryPageTitle : constant.appName;

    property bool prevEnabled: currentIndex > 0 || page > 0;

    ListModel {
        id: albumImagesModel;
    }
    ListModel {
        id: albumImagesMoreModel;
    }

    ListModel {
        id: commentsModel;
    }

    signal load();

    onLoad: {
        //console.log("galleryPage.onLoad: total=" + galleryModel.count + ", currentIndex=" + currentIndex);
        albumImagesModel.clear();
        albumImagesMoreModel.clear();
        commentsModel.clear();

        albumTitle = galleryModel.get(currentIndex).title;
        imgur_id = galleryModel.get(currentIndex).id;
        is_album = galleryModel.get(currentIndex).is_album;

        if (is_album === true) {
            galleryPageTitle = qsTr("Gallery album");
            Imgur.getAlbum(imgur_id);
        } else {
            galleryPageTitle = qsTr("Gallery image");
            Imgur.getGalleryImage(imgur_id);
        }

        if (settings.showComments) {
            Imgur.getAlbumComments(imgur_id);
        }
        setPrevButton();
        galleryFlickable.scrollToTop();
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

        PageHeader { id: header; title: galleryPageTitle; }

        anchors.fill: parent;
        contentHeight: contentArea.height;

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right;}
            height: childrenRect.height;

            anchors.leftMargin: constant.paddingSmall;
            anchors.rightMargin: constant.paddingSmall;

            Label {
                id: titleText;
                anchors { left: parent.left; right: parent.right; }
                wrapMode: Text.Wrap;
                font.pixelSize: constant.fontSizeXSmall;
                text: albumTitle;
            }

            Column {
                id: galleryColumn;
                anchors { left: parent.left; right: parent.right; }
                height: albumListView.height + showMoreButton.height;
                width: parent.width;

                Flow {
                    id: albumListView;
                    height: childrenRect.height;
                    width: parent.width;
                    clip: true;

                    Repeater {
                        model: albumImagesModel;

                        delegate: GalleryDelegate {
                            id: galleryDelegate;
                        }
                    }
                }
                Item {
                    id: showMoreItem;
                    width: parent.width;
                    height: visible ? showMoreButton.height + 2 * constant.paddingSmall : 0;
                    visible: albumImagesMoreModel.count > 0;

                    Button {
                        id: showMoreButton;
                        anchors.centerIn: parent;
                        enabled: albumImagesMoreModel.count > 0;
                        text: qsTr("show more");
                        onClicked: {
                            // @Hack, better way to combine models?
                            for(var i=0; i < albumImagesMoreModel.count; i++) {
                                albumImagesModel.append(albumImagesMoreModel.get(i));
                            }
                            albumImagesMoreModel.clear();
                        }
                    }
                }
            } // galleryColumn

            Column {
                id: albumInfoColumn;
                anchors { left: parent.left; right: parent.right; }
                height: albumInfo.height + infoColumn.height + constant.paddingSmall;
                spacing: constant.paddingSmall;

                ListItem {
                    id: albumInfo;
                    anchors { left: parent.left; right: parent.right; }
                    height: childrenRect.height;

                    ListItem {
                        id: actionAndPointsItem;
                        anchors { left: parent.left; right: parent.right; }

                        ListItem {
                            id: actionButtons;
                            anchors { left: parent.left;}
                            anchors.verticalCenter: parent.verticalCenter;
                            width: 3 * 62 + 3 * constant.paddingLarge;
                            height: 62;

                            IconButton {
                                id: likeButton;
                                anchors { left: parent.left; }
                                icon.source: (vote === "up") ? constant.iconLiked : constant.iconLike;
                                enabled: loggedIn;
                                width: 62;
                                height: 62;
                                onClicked: {
                                    //console.log("Like!");
                                    Imgur.galleryVote(imgur_id, "up",
                                        function (data) {
                                            //infoBanner.showText(data);
                                            //console.log("Like success: " + vote);
                                            if (vote === "up") {
                                                vote = "";
                                            } else {
                                                vote = "up";
                                            }
                                        },
                                        function(status, statusText) {
                                            infoBanner.showHttpError(status, statusText);
                                        }
                                    );
                                }
                            }
                            IconButton {
                                id: dislikeButton;
                                anchors { left: likeButton.right; leftMargin: constant.paddingLarge; }
                                icon.source: (vote === "down") ? constant.iconDisliked : constant.iconDislike;
                                enabled: loggedIn;
                                width: 62;
                                height: 62;
                                onClicked: {
                                    //console.log("Dislike!");
                                    Imgur.galleryVote(imgur_id, "down",
                                        function (data) {
                                            //infoBanner.showText(data);
                                            //console.log("Dislike success: " + vote);
                                            if (vote === "down") {
                                                vote = "";
                                            } else {
                                                vote = "down";
                                            }
                                        },
                                        function(status, statusText) {
                                            infoBanner.showHttpError(status, statusText);
                                        }
                                    );
                                }
                            }
                            IconButton {
                                id: favoriteButton;
                                anchors { left: dislikeButton.right; leftMargin: constant.paddingLarge; rightMargin: constant.paddingLarge; }
                                icon.source: (favorite) ? constant.iconFavorited : constant.iconFavorite;
                                enabled: loggedIn;
                                width: 62;
                                height: 62;
                                onClicked: {
                                    //console.log("Hearth!");
                                    if (is_album) {
                                        Imgur.albumFavorite(imgur_id,
                                            function (data) {
                                                //console.log("data: " + data);
                                                //infoBanner.showText(data);
                                                if (data === "favorited") {
                                                   favorite = true;
                                                } else if (data === "unfavorited") {
                                                    favorite = false;
                                                }
                                            },
                                            function(status, statusText) {
                                                infoBanner.showHttpError(status, statusText);
                                            }
                                        );
                                    }
                                    else {
                                        Imgur.imageFavorite(imgur_id,
                                            function (data) {
                                                //console.log("data: " + data);
                                                //infoBanner.showText(data);
                                                if (data === "favorited") {
                                                   favorite = true;
                                                } else if (data === "unfavorited") {
                                                    favorite = false;
                                                }
                                            },
                                            function(status, statusText) {
                                                infoBanner.showHttpError(status, statusText);
                                            }
                                        );
                                    }
                                }
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
                                font.pixelSize: constant.fontSizeXSmall;
                                text: score + " points";
                            }

                            Rectangle {
                                id: scoreUps;
                                anchors { left: scoreText.right; leftMargin: constant.paddingLarge; }
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
                            font.pixelSize: constant.fontSizeXSmall;
                            text: "by " + account_url + ", " + views + " views";
                        }
                   }
                }
            } // albumInfoColumn

            Column {
                id: commentsColumn;
                anchors { left: parent.left; right: parent.right; }
                height: childrenRect.height + showCommentsItem.height + 200;
                width: parent.width;

                Item {
                    id: showCommentsItem;
                    width: parent.width
                    height: visible ? showCommentsButton.height + 2 * constant.paddingSmall : 0;
                    visible: commentsModel.count == 0;

                    Button {
                        id: showCommentsButton;
                        anchors.centerIn: parent;
                        text: qsTr("show comments");
                        onClicked: {
                            if(commentsModel.count > 0) {
                                commentsColumn.visible = true;
                            } else {
                                Imgur.getAlbumComments(galleryModel.get(currentIndex).id);
                                commentsColumn.visible = true;
                            }
                        }
                    }
                }

                SilicaListView {
                    id: commentListView;
                    model: commentsModel;
                    height: childrenRect.height;
                    width: parent.width;
                    spacing: constant.paddingSmall;
                    clip: true;
                    visible: commentsModel.count > 0;

                    delegate: Loader {
                        id: commentsLoader;
                        width: ListView.view.width;

                        sourceComponent: CommentDelegate {
                            id: commentDelegate;
                        }
                    }
                }
            } // commentsColumn

            Item {
                id: loadingRectComments;
                anchors.centerIn: commentsColumn;
                anchors.horizontalCenter: parent.horizontalCenter;
                visible: false;
                z: 2;

                BusyIndicator {
                    anchors.centerIn: parent;
                    visible: loadingRectComments.visible;
                    running: visible;
                    size: BusyIndicatorSize.Medium;
                    Behavior on opacity { FadeAnimation {} }
                }
            }
        }
        VerticalScrollDecorator {}
    }

    GalleryNavigation {
        id: galleryNavigation;
    }

    Component.onCompleted: {
        albumImagesModel.clear();
        commentsModel.clear();
    }
}
