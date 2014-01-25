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
        anchors { left: depthRow.right; right: parent.right; leftMargin: Theme.paddingSmall; }
        contentHeight: commentColumn.height + 2 * Theme.paddingMedium;

        Column {
            id: commentColumn;
            anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; }
            height: commentText.paintedHeight + commentMeta.height;
            spacing: Theme.paddingSmall;

            Label {
                id: commentText;
                anchors { left: parent.left; right: parent.right; }
                wrapMode: Text.Wrap;
                text: comment;
                textFormat: Text.RichText;
                font.pixelSize: Theme.fontSizeExtraSmall;
                height: commentText.paintedHeight;
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
                anchors { left: commentText.right; right: parent.right; leftMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium; }
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
                    font.pixelSize: Theme.fontSizeExtraSmall;
                }

                Label {
                    id: commentPoints;
                    anchors { left: commentAuthor.right; }
                    text: ", " + points + " points";
                    font.pixelSize: Theme.fontSizeExtraSmall;
                }

                Label {
                    id: commentDatetime;
                    anchors { left: commentPoints.right; leftMargin: Theme.paddingSmall; right: parent.right; }
                    text: ": " + datetime;
                    font.pixelSize: Theme.fontSizeExtraSmall;
                    elide: Text.ElideRight;
                }
            }
        }

        Separator {
            anchors { left: parent.left; right: parent.right; }
            color: Theme.secondaryColor;
        }
    }

    Component {
        id: commentContextMenu;

        ImageContextMenu {
            url: contextLink;
        }
    }

}
