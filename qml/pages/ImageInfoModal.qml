import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: root;
    anchors { left: parent.left; right: parent.right; top: parent.top; bottom: parent.bottom; }
    color: Theme.highlightBackgroundColor;
    opacity: 0.9;
    visible: false;

    property string image_id: '';
    property int image_width: 0;
    property int image_height: 0;
    property string type: '';
    property bool animated: false;
    property string size: '';
    property int views: 0;
    property string bandwith: '';
    //property int comments: 0;
    //property int favorites: 0;
    property string section: '';
    property bool nsfw: false;
    property int ups: 0;
    property int downs: 0;

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            root.visible = false;
        }
    }

    Column {
        anchors { left: parent.left; right: parent.right; }
        anchors { leftMargin: constant.paddingMedium; rightMargin: constant.paddingMedium; }

        Label {
            text: qsTr('Information for image ') + imgur_id;
            font.pixelSize: Theme.fontSizeSmall;
            wrapMode: Text.WrapAnywhere;
        }

        Row {
            Label {
                text: qsTr('Id: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }

            Label {
                text: root.image_id;
                font.pixelSize: Theme.fontSizeExtraSmall;
            }
        }

        Row {
            Label {
                text: qsTr('Width: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
            }

            Label {
                text: root.image_width;
                font.pixelSize: Theme.fontSizeExtraSmall;
            }
        }

        Row {
            Label {
                text: qsTr('Height: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
            }

            Label {
                text: root.image_height;
                font.pixelSize: Theme.fontSizeExtraSmall;
            }
        }

        Row {
            Label {
                text: qsTr('Type: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }

            Label {
                text: root.type;
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }
        }

        Row {
            Label {
                text: qsTr('Size: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
            }

            Label {
                text: root.size;
                font.pixelSize: Theme.fontSizeExtraSmall;
            }
        }

        Row {
            Label {
                text: qsTr('Views: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
            }

            Label {
                text: root.views;
                font.pixelSize: Theme.fontSizeExtraSmall;
            }
        }

        Row {
            Label {
                text: qsTr('Bandwidth: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }

            Label {
                text: root.bandwith;
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }
        }

        Row {
            Label {
                text: qsTr('Section: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }

            Label {
                text: root.section;
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }
        }

        Row {
            Label {
                text: qsTr('Animated: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }

            Label {
                text: root.animated;
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }
        }

        Row {
            Label {
                text: qsTr('NSFW: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }

            Label {
                text: root.nsfw;
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }
        }

        Row {
            Label {
                text: qsTr('Upvotes: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }

            Label {
                text: root.ups;
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }
        }

        Row {
            Label {
                text: qsTr('Downvotes: ');
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }

            Label {
                text: root.downs;
                font.pixelSize: Theme.fontSizeExtraSmall;
                wrapMode: Text.WrapAnywhere;
            }
        }
    }

    Behavior on opacity { FadeAnimation {} }
}
