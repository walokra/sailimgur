import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Column {
    id: albumInfoColumn;
    anchors { left: parent.left; right: parent.right; }
    height: actionButtons.height + infoText.height + constant.paddingSmall + ((writeCommentField.visible) ? writeCommentField.height : 0);
    spacing: constant.paddingSmall;
    visible: is_gallery == true;

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

    ListItem {
        id: actionButtons;
        anchors { left: parent.left; right: parent.right; }
        height: 62;

        Rectangle {
            id: likeRect;
            width: 48;
            height: 48;
            anchors { left: parent.left; }

            radius: 75;
            color: (galleryContentModel.vote === "up") ? "green" : constant.iconDefaultColor;

            IconButton {
                id: likeButton;
                anchors.centerIn: parent;
                enabled: loggedIn;
                icon.width: Theme.itemSizeExtraSmall;
                icon.height: Theme.itemSizeExtraSmall;
                icon.source: constant.iconLike;
                onClicked: {
                    internal.galleryVote("up");
                }
            }
        }

        Rectangle {
            id: dislikeRect;
            width: 48;
            height: 48;
            anchors { left: likeRect.right; leftMargin: constant.paddingExtraLarge; }

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
            id: favRect;
            width: 52;
            height: 52;
            anchors { left: dislikeRect.right; leftMargin: constant.paddingExtraLarge; }

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

        IconButton {
            id: replyButton;
            anchors { left: favRect.right; leftMargin: constant.paddingExtraLarge; }
            enabled: loggedIn;
            width: 48;
            height: 48;
            icon.width: Theme.itemSizeExtraSmall;
            icon.height: Theme.itemSizeExtraSmall;
            icon.source: constant.iconComments;
            onClicked: {
                if (writeCommentField.visible) {
                    writeCommentField.visible = false;
                } else {
                    writeCommentField.visible = true;
                }
            }
        }

        Item {
            id: pointColumn;
            //anchors { top: parent.top; left: replyButton.right; right: parent.right; leftMargin: constant.paddingExtraLarge; }
            anchors { top: parent.top; right: parent.right; rightMargin: constant.paddingLarge; }
            height: childrenRect.height;

            Label {
                id: scoreText;
                anchors { right: parent.right; top: parent.top; }
                anchors.verticalCenter: parent.verticalCenter;
                anchors.bottomMargin: constant.paddingSmall;
                font.pixelSize: constant.fontSizeXXSmall;
                text: galleryContentModel.score + " points";
                color: constant.colorHighlight;
            }

            ListItem {
                id: scoreBars;
                anchors { right: parent.right; top: scoreText.bottom; }
                anchors.verticalCenter: parent.verticalCenter;

                Rectangle {
                    id: scoreUps;
                    anchors { right: scoreDowns.left; }
                    anchors.verticalCenter: parent.verticalCenter;
                    width: 100 * (galleryContentModel.upsPercent/100);
                    height: 10;
                    color: "green";
                }

                Rectangle {
                    id: scoreDowns;
                    anchors { right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    width: 100 * (galleryContentModel.downsPercent/100);
                    height: 10;
                    color: "red";
                }
            }
        }
    }

    Label {
        id: infoText;
        anchors { left: parent.left; right: parent.right; topMargin: constant.paddingMedium; }
        wrapMode: Text.Wrap;
        font.pixelSize: constant.fontSizeXSmall;
        color: constant.colorHighlight;
        text: qsTr("by") + " " + galleryContentModel.account_url + ", " + galleryContentModel.views + " " + qsTr("views");
    }

    TextArea {
        id: writeCommentField;
        anchors { left: parent.left; right: parent.right; }
        anchors.topMargin: constant.paddingMedium;
        visible: false;
        placeholderText: qsTr("Write comment");

        EnterKey.enabled: text.trim().length > 0;
        EnterKey.iconSource: "image://theme/icon-m-enter-accept";
        EnterKey.onClicked: {
            //console.log("Comment: " + text);
            Imgur.commentCreation(imgur_id, text, null,
                  function (data) {
                      //console.log("data: " + JSON.stringify(data));
                      infoBanner.showText(qsTr("Comment sent!"));
                      visible = false;
                      text = "";
                      writeCommentField.focus = false;

                      commentsModel.getComments(imgur_id);
                  },
                  function(status, statusText) {
                      infoBanner.showHttpError(status, statusText);
                  }
            );
        }
    }

} // albumInfoColumn
