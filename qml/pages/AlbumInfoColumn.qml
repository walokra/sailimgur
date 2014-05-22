import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Column {
    id: albumInfoColumn;
    anchors { left: parent.left; right: parent.right; }
    height: actionButtons.height + infoText.height + constant.paddingSmall + ((writeCommentField.visible) ? writeCommentField.height : 0);
    spacing: constant.paddingSmall;
    visible: is_gallery == true;

    ListItem {
        id: actionButtons;
        anchors { left: parent.left; }
        width: 4 * 62 + 4 * constant.paddingLarge;
        height: 62;

        IconButton {
            id: likeButton;
            anchors { left: parent.left; }
            icon.source: (galleryContentModel.vote === "up") ? constant.iconLiked : constant.iconLike;
            enabled: loggedIn;
            width: 62;
            height: 62;
            onClicked: {
                //console.log("Like!");
                Imgur.galleryVote(imgur_id, "up",
                    function (data) {
                        //infoBanner.showText(data);
                        //console.log("Like success: " + vote);
                        if (galleryContentModel.vote === "up") {
                            galleryContentModel.vote = "";
                        } else {
                            galleryContentModel.vote = "up";
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
            icon.source: (galleryContentModel.vote === "down") ? constant.iconDisliked : constant.iconDislike;
            enabled: loggedIn;
            width: 62;
            height: 62;
            onClicked: {
                //console.log("Dislike!");
                Imgur.galleryVote(imgur_id, "down",
                    function (data) {
                        //infoBanner.showText(data);
                        //console.log("Dislike success: " + vote);
                        if (galleryContentModel.vote === "down") {
                            galleryContentModel.vote = "";
                        } else {
                            galleryContentModel.vote = "down";
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
            icon.source: (galleryContentModel.favorite) ? constant.iconFavorited : constant.iconFavorite;
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
                            //console.log("data: " + data);
                            //infoBanner.showText(data);
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

        IconButton {
            id: replyButton;
            anchors { left: favoriteButton.right; leftMargin: constant.paddingLarge; rightMargin: constant.paddingLarge; }
            icon.source: constant.iconMoreComments;
            enabled: loggedIn;
            icon.height: 62;
            icon.width: 62;
            width: 62;
            height: 62;
            onClicked: {
                //console.log("Write comment action");
                if (writeCommentField.visible) {
                    writeCommentField.visible = false;
                } else {
                    writeCommentField.visible = true;
                }
            }
        }

        Item {
            id: pointColumn;
            anchors { top: parent.top; right: parent.right; }
            anchors.leftMargin: constant.paddingMedium;
            height: childrenRect.height;

            Label {
                id: scoreText;
                anchors { left: parent.left; right: parent.right; top: parent.top; }
                anchors.verticalCenter: parent.verticalCenter;
                anchors.bottomMargin: constant.paddingSmall;
                font.pixelSize: constant.fontSizeXXSmall;
                text: galleryContentModel.score + " points";
                color: constant.colorHighlight;
            }

            ListItem {
                id: scoreBars;
                anchors { left: parent.left; top: scoreText.bottom; }
                anchors.verticalCenter: parent.verticalCenter;

                Rectangle {
                    id: scoreUps;
                    anchors { left: parent.left; }
                    anchors.verticalCenter: parent.verticalCenter;
                    width: 100 * (galleryContentModel.upsPercent/100);
                    height: 10;
                    color: "green";
                }

                Rectangle {
                    id: scoreDowns;
                    anchors { left: scoreUps.right; }
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
        anchors { left: parent.left; right: parent.right; }
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
                      console.log("data: " + JSON.stringify(data));
                      infoBanner.showText(qsTr("Comment sent!"));
                      visible = false;
                      text = "";
                      writeCommentField.focus = false;
                  },
                  function(status, statusText) {
                      infoBanner.showHttpError(status, statusText);
                  }
            );
        }
    }

} // albumInfoColumn
