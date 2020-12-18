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
                if (loggedIn) {
                    if (commentActionButtons.visible) {
                        commentActionButtons.visible = false;
                    } else {
                        commentActionButtons.visible = true;
                    }
                } else {
                    commentActionButtons.visible = false;
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

                property var fontSize: constant.fontSizeIgnore

                Label {
                    id: commentAuthor;
                    anchors { left: parent.left; }
                    wrapMode: Text.Wrap;
                    text: author;
                    font.pixelSize: parent.fontSize;
                }

                Label {
                    id: commentPoints;
                    anchors { left: commentAuthor.right; }
                    text: ", " + points + "p";
                    font.pixelSize: parent.fontSize;
                }

                Label {
                    id: commentDatetime;
                    anchors { left: commentPoints.right; leftMargin: constant.paddingSmall; right: parent.right; }
                    text: ", " + datetime;
                    font.pixelSize: parent.fontSize;
                    elide: Text.ElideRight;
                }
            }

            Label {
                id: commentText;
                anchors { left: parent.left; right: parent.right; }
                wrapMode: Text.Wrap;
                text: comment;
                font.pixelSize: constant.fontSizeNormal;
                height: commentText.paintedHeight;
                textFormat: Text.StyledText;
                linkColor: Theme.highlightColor;
                onLinkActivated: {
                    contextLink = link;
                    contextMenu = commentContextMenu.createObject(commentListView);
                    contextMenu.open(commentDelegate);
                    contextMenu.x = depthRow.x + depthRow.width;
                }
            }

            ListItem {
                id: commentActionButtons;
                anchors { left: parent.left; leftMargin: constant.paddingSmall; }
                width: parent.width;
                height: 75;
                visible: false;

                Rectangle {
                    id: likeRect;
                    width: 36;
                    height: 36;
                    anchors { left: parent.left; leftMargin: constant.paddingLarge; }
                    anchors.verticalCenter: parent.verticalCenter;

                    radius: 75;
                    color: (vote === "up") ? "green" : constant.iconDefaultColor;

                    IconButton {
                        id: likeButton;
                        anchors.centerIn: parent;
                        enabled: loggedIn;
                        icon.width: 42;
                        icon.height: 42;

                        icon.source: constant.iconLike;
                        onClicked: {
                            commentsModel.commentVote(id, "up");
                        }
                    }
                }

                Rectangle {
                    id: dislikeRect;
                    width: 36;
                    height: 36;
                    anchors { left: likeRect.right; leftMargin: constant.paddingLarge; }
                    anchors.verticalCenter: parent.verticalCenter;

                    radius: 75;
                    color: (vote === "down") ? "red" : constant.iconDefaultColor;

                    IconButton {
                        id: dislikeButton;
                        anchors.centerIn: parent;
                        enabled: loggedIn;
                        icon.height: 42;
                        icon.width: 42;

                        icon.source: constant.iconDislike;
                        onClicked: {
                            commentsModel.commentVote(id, "down");
                        }
                    }
                }

                IconButton {
                    id: replyButton;
                    anchors { left: dislikeRect.right; leftMargin: constant.paddingLarge; }
                    anchors.verticalCenter: parent.verticalCenter;
                    enabled: loggedIn;
                    icon.height: 42;
                    icon.width: 42;

                    icon.source: constant.iconComments;
                    onClicked: {
                        if (writeCommentField.visible) {
                            writeCommentField.visible = false;
                        } else {
                            writeCommentField.visible = true;
                        }
                    }
                }

                Rectangle {
                    id: deleteRect;
                    width: 38;
                    height: 38;
                    anchors { right: parent.right; rightMargin: constant.paddingLarge; }
                    anchors.verticalCenter: parent.verticalCenter;
                    visible: loggedIn && author === settings.user;

                    radius: 75;
                    color: constant.iconDefaultColor;

                    IconButton {
                        id: deleteButton;
                        anchors.centerIn: parent;
                        enabled: loggedIn;
                        icon.height: 42;
                        icon.width: 42;

                        icon.source: constant.iconDelete;
                        onClicked: {
                            commentsModel.commentDelete(id);
                        }
                    }
                }
            }

            TextArea {
                id: writeCommentField;
                anchors { left: parent.left; right: parent.right; }
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
    }

    Component {
        id: commentContextMenu;

        ImageContextMenu {
            url: contextLink;
        }
    }
}
