import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: commentDelegate;

    width: ListView.view.width
    height: commentItem.height;

    ListItem {
        id: commentItem;
        anchors { left: parent.left; right: parent.right; }
        //height: commentText.height + commentMeta.height;
        contentHeight: commentColumn.height + 2 * Theme.paddingMedium;

        Column {
            id: commentColumn
            anchors {
                left: parent.left; right: parent.right; margins: Theme.paddingMedium
                verticalCenter: parent.verticalCenter
            }
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
                    console.log("Link clicked!");
                    //basicHapticEffect.play();
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
                    // if text is too wide, adds ...
                    elide: Text.ElideRight;
                }
            }

            /*
            IconButton {
                id: more;
                anchors { right: parent.right; leftMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium; }
                icon.source: "../images/icons/more-comments.svg";
                width: 31;
                height: 31;
                onClicked: {
                    console.log("Show comment's childrens");
                }
                //anchors.verticalCenter: parent.verticalCenter;
                enabled: false;
                visible: hasChildren;
            }
            */
        }

        Separator {
            anchors { left: parent.left; right: parent.right; }
            color: Theme.secondaryColor;
            //alignment: Qt.AlignHCenter;
        }
    }
}
