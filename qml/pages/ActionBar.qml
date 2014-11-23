import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: root;
    height: toolbar.height + galleryMode.height;
    anchors { left: parent.left; right: parent.right; }
    z: -1;
    opacity: 1;

    property Flickable flickable;

    Toolbar { id: toolbar; }

    GalleryMode { id: galleryMode; }

    /*
    Timer {
        id: timer;
        property bool moving: galgrid.moving || galgrid.dragging || galgrid.flicking;
        onMovingChanged: if (!moving) restart();
        interval: 300;
    }
    */

    Behavior on opacity { FadeAnimation { duration: 300; } }
    Behavior on height { NumberAnimation { easing.type: Easing.Linear; } }

    Connections {
        target: flickable
        onFlickingVerticallyChanged: {
            //console.debug("onFlickingVerticallyChanged, velocity=" + flickable.verticalVelocity);
            if (flickable.atYBeginning) {
                actionBar.height = toolbar.height + galleryMode.height;
                actionBar.opacity = 1;
            }

            if (flickable.verticalVelocity < 0) {
                actionBar.height = toolbar.height + galleryMode.height;
                actionBar.opacity = 1;
            }
            if (flickable.verticalVelocity > 0) {
                actionBar.height = 0;
                actionBar.opacity = 0;
            }
        }
    }
}
