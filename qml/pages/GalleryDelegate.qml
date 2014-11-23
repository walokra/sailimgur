import QtQuick 2.0
import Sailfish.Silica 1.0

Image {
    id: image;
    asynchronous: true;
    anchors.centerIn: parent;

    width: (deviceOrientation === Orientation.Landscape || deviceOrientation === Orientation.LandscapeInverted) ? galgrid.width / 5 : galgrid.width / 3;
    height: (deviceOrientation === Orientation.Landscape || deviceOrientation === Orientation.LandscapeInverted) ? galgrid.width / 5 : galgrid.width / 3;

    smooth: false;
    source: link;
    MouseArea {
        anchors.fill: parent;
        onClicked: {
            //console.log("galgrid: details for id=" + id + "; title=" + title + "; index=" + index);
            currentIndex = index;
            pageStack.push(galleryContentPage);
            galleryContentPage.load();
        }
    }

    Rectangle {
        id: voteIndicator;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: constant.paddingMedium;

        color: {
            if (vote === "up") {
                "green";
            } else if (vote === "down") {
                "red";
            } else {
                "transparent";
            }
        }
        width: 24;
        height: 6;
    }
}
