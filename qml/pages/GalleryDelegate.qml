import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    z: 1;
    width: (deviceOrientation === Orientation.Landscape || deviceOrientation === Orientation.LandscapeInverted) ? galgrid.width / 5 : galgrid.width / 3;
    height: width;

    Image {
        id: image;
        z: -3;
        asynchronous: true;
        anchors.centerIn: parent;

        width: parent.width
        height: parent.height

        smooth: false;
        source: link;

        /*
        Rectangle {
            id: gradient;
            width: parent.width;
            height: parent.height / 2;
            anchors.bottom: parent.bottom;
            gradient: Gradient {
                GradientStop { position: 0; color: "#00000000"; }
                GradientStop { position: 1; color: "#FF000000"; }
              }
        }
        */

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

            radius: constant.paddingSmall / 2;
            width: constant.paddingLarge;
            height: constant.paddingSmall;
        }
    }
    onClicked: {
        //console.log("galgrid: details for id=" + id + "; title=" + title + "; index=" + index);
        currentIndex = index;
        pageStack.push(galleryContentPage);
        galleryContentPage.load();
    }
}
