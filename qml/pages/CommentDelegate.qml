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

        Column {
            id: commentColumn;
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; }
            height: commentText.paintedHeight + commentMeta.height;
            spacing: constant.paddingSmall;

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

            /*
            IconButton {
                id: more;
                anchors { left: commentText.right; right: parent.right; leftMargin: constant.paddingMedium; rightMargin: constant.paddingMedium; }
                icon.source: "../images/icons/more-comments.svg";
                width: 31;
                height: 31;
                onClicked: {
                    console.log("Show comment's childrens");
                }
                enabled: false;
                visible: childrens > 0;
            }
            */

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
