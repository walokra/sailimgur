import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: root;
    allowedOrientations: Orientation.All;

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

    SilicaFlickable {
        id: flickable;

        anchors.fill: parent;
        contentHeight: contentArea.height;

        PageHeader {
            id: header
            title: qsTr("Image information");
        }

        Column {
            id: contentArea;

            anchors {
                top: header.bottom;
                left: parent.left;
                right: parent.right;
                margins: Theme.horizontalPageMargin;
            }

            property var fontSize: constant.fontSizeNormal;

            height: childrenRect.height;
            spacing: constant.paddingMedium;

            anchors { left: parent.left; right: parent.right; }
            anchors { leftMargin: constant.paddingMedium; rightMargin: constant.paddingMedium; }

            DetailItem {
                label: qsTr('Id');
                value: root.image_id;
            }

            DetailItem {
                label: qsTr('Width');
                value: root.image_width;
            }

            DetailItem {
                label: qsTr('Height');
                value: root.image_height;
            }

            DetailItem {
                label: qsTr('Type');
                value: root.type;
            }

            DetailItem {
                label: qsTr('Size');
                value: root.size;
            }

            DetailItem {
                label: qsTr('Views');
                value: root.views;
            }

            DetailItem {
                label: qsTr('Bandwidth');
                value: root.bandwith;
            }

            DetailItem {
                label: qsTr('Section');
                value: root.section;
            }

            DetailItem {
                label: qsTr('Animated');
                value: root.animated;
            }

            DetailItem {
                label: qsTr('NSFW');
                value: root.nsfw;
            }

            DetailItem {
                label: qsTr('Upvotes');
                value: root.ups;
            }

            DetailItem {
                label: qsTr('Downvotes');
                value: root.downs;
            }

        }

        VerticalScrollDecorator { flickable: flickable; }
    }

}
