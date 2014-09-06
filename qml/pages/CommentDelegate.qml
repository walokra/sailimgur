import QtQuick 2.0
import Sailfish.Silica 1.0

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

            Item {
                id: commentMeta;
                anchors { left: parent.left; right: parent.right; }
                height: commentPoints.height

                Label {
                    id: commentAuthor;
                    anchors { left: parent.left; }
                    wrapMode: Text.Wrap;
                    text: author;
                    font.pixelSize: constant.fontSizeXXSmall;
                }

                Label {
                    id: commentPoints;
                    anchors { left: commentAuthor.right; }
                    text: ", " + points + "p";
                    font.pixelSize: constant.fontSizeXXSmall;
                }

                Label {
                    id: commentDatetime;
                    anchors { left: commentPoints.right; leftMargin: constant.paddingSmall; right: parent.right; }
                    text: ", " + datetime;
                    font.pixelSize: constant.fontSizeXXSmall;
                    elide: Text.ElideRight;
                }
            }

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
                    contextLink = link;
                    contextMenu = commentContextMenu.createObject(commentListView);
                    contextMenu.show(commentDelegate);
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
                    anchors.leftMargin: constant.paddingMedium;
                    icon.source: (vote === "up") ? constant.iconLiked : constant.iconLike;
                    enabled: loggedIn;
                    icon.height: 31;
                    icon.width: 31;
                    width: 62;
                    height: 62;
                    onClicked: {
                        commentsModel.commentVote(id, "up");
                    }
                }

                IconButton {
                    id: dislikeButton;
                    anchors { left: likeButton.right; leftMargin: constant.paddingLarge; }
                    icon.source: (vote === "down") ? constant.iconDisliked : constant.iconDislike;
                    enabled: loggedIn;
                    icon.height: 31;
                    icon.width: 31;
                    width: 62;
                    height: 62;
                    onClicked: {
                        commentsModel.commentVote(id, "down");
                    }
                }

                Label {
                    id: deleteButton;
                    anchors { right: replyButton.left; }
                    anchors.rightMargin: 2 * constant.paddingLarge;
                    visible: loggedIn && author === settings.user;
                    text: qsTr("delete");
                    font.pixelSize: constant.fontSizeXSmall;
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            commentsModel.commentDelete(id);
                        }
                    }
                }

                Label {
                    id: replyButton;
                    anchors { right: parent.right; }
                    anchors.rightMargin: constant.paddingLarge;
                    enabled: loggedIn;
                    text: qsTr("reply");
                    font.pixelSize: constant.fontSizeXSmall;
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            if (writeCommentField.visible) {
                                writeCommentField.visible = false;
                            } else {
                                writeCommentField.visible = true;
                            }
                        }
                    }
                }

                /*
                IconButton {
                    id: deleteButton;
                    anchors { left: dislikeButton.right; leftMargin: constant.paddingLarge; }
                    icon.source: constant.iconDelete;
                    enabled: loggedIn && author === settings.user;
                    width: 62;
                    height: 62;
                    onClicked: {
                        commentsModel.commentDelete(id);
                    }
                }
                */

                /*
                IconButton {
                    id: replyButton;
                    anchors { left: deleteButton.right; right: parent.right; rightMargin: constant.paddingLarge; }
                    icon.source: constant.iconReply;
                    enabled: loggedIn;
                    width: 62;
                    height: 62;
                    onClicked: {
                        if (writeCommentField.visible) {
                            writeCommentField.visible = false;
                        } else {
                            writeCommentField.visible = true;
                        }
                    }
                }*/
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
                    commentsModel.commentCreate(imgur_id, id, text,
                        function (data) {
                            infoBanner.showText(qsTr("Comment sent!"));
                            visible = false;
                            text = "";
                            writeCommentField.focus = false;
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
