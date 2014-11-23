import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: galleryDelegate;

    color: "transparent";
    border.color: {
        if (vote === "up") {
            "green";
        } else if (vote === "down") {
            "red";
        } else {
            "transparent";
        }
    }
    border.width: {
        if (vote === "up" || vote === "down") {
            3;
        } else {
            0;
        }
    }
    width: 166;
    height: 166;

    Image {
        id: image;
        asynchronous: true;
        anchors.centerIn: parent;

        width: 160;
        height: 160;

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
    }
}
