import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Item {
    id: albumInfoColumn;
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom; bottomMargin: constant.paddingMedium; }
    height: actionButtons.height + constant.paddingSmall;
    visible: is_gallery == true;
    z: 9;

    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            //console.log("Keys.onPressed=" + event.key);
            if (event.key === Qt.Key_0) {
                internal.galleryFavorite(is_album);
                event.accepted = true;
            }
            if (event.key === Qt.Key_Equal) {
                internal.galleryVote("up");
                event.accepted = true;
            }
            if (event.key === Qt.Key_Minus) {
                internal.galleryVote("down");
                event.accepted = true;
            }

            // Navigation
            if (event.key === Qt.Key_Left) {
                galleryNavigation.previous();
                event.accepted = true;
            }
            if (event.key === Qt.Key_Right) {
                galleryNavigation.next();
                event.accepted = true;
            }
            if (event.key === Qt.Key_Down) {
                flickable.flick(0, -1200);
                event.accepted = true;
            }
            if (event.key === Qt.Key_Up) {
                flickable.flick(0, 1200);
                event.accepted = true;
            }

            // More and comments
            if (event.key === Qt.Key_M) {
                galleryContentModel.getNextImages();
                event.accepted = true;
            }
            if (event.key === Qt.Key_C) {
                commentsModel.getComments(imgur_id);
                commentsColumn.visible = true;
            }
        }
    }

    QtObject {
        id: internal;

        function galleryVote(vote) {
            Imgur.galleryVote(imgur_id, vote,
                function (data) {
                    //console.log("Vote success: " + vote);
                    if (galleryContentModel.vote === vote) {
                        galleryContentModel.vote = "";
                    } else {
                        galleryContentModel.vote = vote;
                    }
                },
                function(status, statusText) {
                    infoBanner.showHttpError(status, statusText);
                }
            );
        }

        function galleryFavorite(is_album) {
            if (is_album) {
                Imgur.albumFavorite(imgur_id,
                    function (data) {
                        if (data === "favorited") {
                           galleryContentModel.favorite = true;
                        } else if (data === "unfavorited") {
                            galleryContentModel.favorite = false;
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
                        if (data === "favorited") {
                           galleryContentModel.favorite = true;
                        } else if (data === "unfavorited") {
                            galleryContentModel.favorite = false;
                        }
                    },
                    function(status, statusText) {
                        infoBanner.showHttpError(status, statusText);
                    }
                );
            }
        }
    }

    Row {
        id: actionButtons;
        anchors.horizontalCenter: parent.horizontalCenter;
        width: childrenRect.width;
        height: 64;
        spacing: Theme.paddingLarge * 2;

        Rectangle {
            id: dislikeRect;
            width: 48;
            height: 48;

            radius: 75;
            color: (galleryContentModel.vote === "down") ? "red" : constant.iconDefaultColor;

            IconButton {
                id: dislikeButton;
                anchors.centerIn: parent;
                enabled: loggedIn;
                icon.width: Theme.itemSizeExtraSmall;
                icon.height: Theme.itemSizeExtraSmall;
                icon.source: constant.iconDislike;
                onClicked: {
                    internal.galleryVote("down");
                }
            }
        }

        Rectangle {
            id: likeRect;
            width: 64;
            height: 64;

            radius: 75;
            color: (galleryContentModel.vote === "up") ? "green" : constant.iconDefaultColor;

            IconButton {
                id: likeButton;
                anchors.centerIn: parent;
                enabled: loggedIn;
                icon.width: Theme.itemSizeMedium;
                icon.height: Theme.itemSizeMedium;
                icon.source: constant.iconLike;
                onClicked: {
                    internal.galleryVote("up");
                }
            }
        }

        Rectangle {
            id: favRect;
            width: 52;
            height: 52;

            radius: 75;
            color: (galleryContentModel.favorite) ? "green" : constant.iconDefaultColor;

            IconButton {
                id: favoriteButton;
                anchors.centerIn: parent;
                enabled: loggedIn;
                icon.width: Theme.itemSizeExtraSmall;
                icon.height: Theme.itemSizeExtraSmall;
                icon.source: constant.iconFavorite;
                onClicked: {
                    internal.galleryFavorite(is_album);
                }
            }
        }
    }

} // albumInfoColumn
