import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Item {
    id: commentDelegate;
    property Item contextMenu;
    property bool menuOpen: contextMenu != null && contextMenu.parent === commentDelegate;
    property string contextLink;

    height: menuOpen ? contextMenu.height + commentItem.height : commentItem.height;

    Row {
        id: depthRow;
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom; }

        Repeater {
            model: depth;

            Item {
                anchors { top: parent.top; bottom: parent.bottom; }
                width: 10;

                Rectangle {
                    anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; }
                    width: 2;
                    color: "darkgray";
                }
            }
        }
    }

    ListItem {
        id: commentItem;
        anchors { left: depthRow.right; right: parent.right; leftMargin: constant.paddingSmall; }
        contentHeight: commentColumn.height + 2 * constant.paddingMedium;

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                console.log("Comment actions");

                if (commentActionButtons.visible) {
                    commentActionButtons.visible = false;
                } else {
                    commentActionButtons.visible = true;
                }
            }
        }

        Column {
            id: commentColumn;
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; }
            height: commentText.paintedHeight + commentMeta.height
                    + ((commentActionButtons.visible) ? commentActionButtons.height : 0)
                    + ((writeCommentField.visible) ? writeCommentField.height: 0);
            //spacing: constant.paddingSmall;

            Label {
                id: commentText;
                anchors { left: parent.left; right: parent.right; }
                wrapMode: Text.Wrap;
                text: comment;
                font.pixelSize: constant.fontSizeXSmall;
                height: commentText.paintedHeight;
                textFormat: Text.StyledText;
                linkColor: Theme.highlightColor;
                onLinkActivated: {
                    //console.log("Link clicked! " + link);
                    contextLink = link;
                    contextMenu = commentContextMenu.createObject(commentListView);
                    contextMenu.show(commentDelegate);
                }
            }

            Item {
                id: commentMeta;
                anchors { left: parent.left; right: parent.right; }
                height: commentPoints.height

                Label {
                    id: commentAuthor;
                    anchors { left: parent.left; }
                    wrapMode: Text.Wrap;
                    text: "by " + author;
                    font.pixelSize: constant.fontSizeXSmall;
                }

                Label {
                    id: commentPoints;
                    anchors { left: commentAuthor.right; }
                    text: ", " + points + " points";
                    font.pixelSize: constant.fontSizeXSmall;
                }

                Label {
                    id: commentDatetime;
                    anchors { left: commentPoints.right; leftMargin: constant.paddingSmall; right: parent.right; }
                    text: ": " + datetime;
                    font.pixelSize: constant.fontSizeXSmall;
                    elide: Text.ElideRight;
                }
            }

            ListItem {
                id: commentActionButtons;
                anchors { left: parent.left; right: parent.right; }
                width: parent.width;
                height: 62;
                visible: false;

                IconButton {
                    id: likeButton;
                    anchors { left: parent.left; }
                    icon.source: constant.iconLike;
                    enabled: loggedIn;
                    icon.height: 31;
                    icon.width: 31;
                    width: 62;
                    height: 62;
                    onClicked: {
                        //console.log("Like comment action");
                        Imgur.commentVote(id, "up",
                            function (data) {
                                //console.log("data=" + JSON.stringify(data));
                                likeButton.icon.source = constant.iconLiked;
                                dislikeButton.icon.source = constant.iconDislike;
                                points += 1;
                                infoBanner.showText("Comment liked!");
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
                    icon.source: constant.iconDislike;
                    enabled: loggedIn;
                    icon.height: 31;
                    icon.width: 31;
                    width: 62;
                    height: 62;
                    onClicked: {
                        //console.log("Dislike comment action");
                        Imgur.commentVote(id, "down",
                            function (data) {
                                //console.log("data=" + JSON.stringify(data));
                                likeButton.icon.source = constant.iconLike;
                                dislikeButton.icon.source = constant.iconDisliked;
                                points -= 1;
                                infoBanner.showText("Comment disliked!");
                            },
                            function(status, statusText) {
                                infoBanner.showHttpError(status, statusText);
                            }
                        );
                    }
                }

                IconButton {
                    id: deleteButton;
                    anchors { left: dislikeButton.right; leftMargin: constant.paddingLarge; }
                    icon.source: constant.iconDelete;
                    enabled: loggedIn && author === settings.user;
                    width: 62;
                    height: 62;
                    onClicked: {
                        //console.log("Delete comment action");
                        Imgur.commentDeletion(id,
                            function (data) {
                                //console.log("data=" + JSON.stringify(data));
                                infoBanner.showText("Comment deleted!");
                            },
                            function(status, statusText) {
                                infoBanner.showHttpError(status, statusText);
                            }
                        );
                    }
                }

                IconButton {
                    id: replyButton;
                    anchors { right: parent.right; rightMargin: constant.paddingLarge; }
                    icon.source: constant.iconReply;
                    enabled: loggedIn;
                    width: 62;
                    height: 62;
                    onClicked: {
                        //console.log("Reply comment action");
                        if (writeCommentField.visible) {
                            writeCommentField.visible = false;
                        } else {
                            writeCommentField.visible = true;
                        }
                    }
                }
            }

            TextArea {
                id: writeCommentField;
                anchors { left: parent.left; right: parent.right; }
                anchors.topMargin: constant.paddingMedium;
                visible: false;
                placeholderText: qsTr("Reply to comment");

                EnterKey.enabled: text.trim().length > 0;
                EnterKey.iconSource: "image://theme/icon-m-enter-accept";
                EnterKey.onClicked: {
                    //console.log("Comment: " + text);
                    Imgur.commentCreation(imgur_id, text, id,
                          function (data) {
                              //console.log("data: " + JSON.stringify(data));
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
        }

        Separator {
            anchors { left: parent.left; right: parent.right; }
            color: constant.colorSecondary;
        }
    }

    Component {
        id: commentContextMenu;

        ImageContextMenu {
            url: contextLink;
        }
    }
}
