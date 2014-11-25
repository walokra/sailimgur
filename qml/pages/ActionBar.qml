import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: root;
    //height: childrenRect.height;
    anchors { left: parent.left; right: parent.right; }
    z: 1;
    property bool shown: true;
    onShownChanged: {
        if (shown) {
//            z = 1;
//            opacity = 1;
            height = childrenRect.height

        } else {
//            opacity = 0;
//            z = -3;
            height = 0
        }
    }

//    visible: shown;
    //opacity: 1;

    property Flickable flickable;

    Toolbar { id: toolbar; }

    GalleryMode { id: galleryMode; }

    Behavior on opacity { FadeAnimation { duration: 30000; } }
//    Behavior on z {FadeAnimation {duration : 3000}}
    Behavior on height { NumberAnimation { easing.type: Easing.Linear; } }

    Connections {
        target: flickable
        onFlickingVerticallyChanged: {
            //console.debug("onFlickingVerticallyChanged, velocity=" + flickable.verticalVelocity);
            if (flickable.atYBeginning) {
                //actionBar.height = actionBar.childrenRect.height;
                //actionBar.opacity = 1;
                actionBar.shown = true;
            }

            if (flickable.verticalVelocity < 0) {
                //actionBar.height = actionBar.childrenRect.height;
                //actionBar.opacity = 1;
                actionBar.shown = true;
            }
            if (flickable.verticalVelocity > 0) {
                //actionBar.height = 0;
                //actionBar.opacity = 0;
                actionBar.shown = false;
            }
        }
    }
}
