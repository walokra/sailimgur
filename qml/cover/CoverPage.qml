import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage;

    anchors.fill: parent;

    signal coverStatusChanged(int coverStatus);

    property int start : 0;

    ListModel {
        id: coverModel;
        property bool loaded : false;
    }

    onStatusChanged: {
        if (status === PageStatus.Deactivating) {
            start = 0;
        }
        if (status === PageStatus.Activating) {
            loadingRect.visible = false;
            fillCoverModel();
        }

        coverStatusChanged(status);
    }

    function fillCoverModel() {
        coverModel.loaded = false;
        coverModel.clear();
        var end = start + 9;
        end = (end < galleryModel.count) ? end : galleryModel.count;
        for (var i=start; i < end; i++) {
            coverModel.append(galleryModel.get(i));
        }
        coverModel.loaded = true;
    }

    Image {
        anchors.left: parent.left;
        anchors.bottom: parent.bottom;
        source: "../images/sailimgur-overlay_292x292.svg";
        opacity: 0.1;
    }

    Flow {
        id: root;
        anchors { top: parent.top; left: parent.left; right: parent.right; }
        anchors.leftMargin: constant.paddingMedium;
        anchors.topMargin: constant.paddingMedium;

        Repeater {
            id: covergrid;
            model: 9;

            delegate: imageDelegate;
        }
    }

    Component {
        id: imageDelegate

        Item {
            width: 73;
            height:  73;

            Image {
                id: image;
                asynchronous: true;

                width: 60;
                height: 60;

                smooth: false;
                source: (coverModel.loaded && coverModel.count > 0 && index < coverModel.count) ? coverModel.get(index).link : "";
                fillMode: Image.PreserveAspectCrop;
            }
        }
    }

    Label {
        anchors { left: parent.left; right: parent.right; top: root.bottom; }
        anchors.leftMargin: constant.paddingLarge;
        visible: galleryModel.busy;
        font.pixelSize: Theme.fontSizeLarge
        color: Theme.highlightColor
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: qsTr("Refreshing")

        Timer {
            property int angle: 0

            running: cover.status === Cover.Active && parent.visible
            interval: 50
            repeat: true

            onTriggered: {
                var a = angle;
                parent.opacity = 0.5 + 0.5 * Math.sin(angle * (Math.PI / 180.0));
                angle = (angle + 10) % 360;
            }
        }
    }

    CoverActionList {
        id: coverAction;

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: {
                galleryModel.processGalleryMode();
            }
        }

//        CoverAction {
//            iconSource: "image://theme/icon-cover-next";
//            onTriggered: {
//                start = start + 9;
//                fillCoverModel();
//            }
//        }
    }

}
