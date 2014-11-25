import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: root;
    anchors { left: parent.left; right: parent.right; }
    z: 1;
    visible: true;

    property bool shown: true;

    onShownChanged: {
        if (shown) {
            // z = 1;
            opacity = 1;
            //height = childrenRect.height
            visible = true;
        } else {
            // z = -3;
            opacity = 0;
            //height = 0;
            visible = false;
        }
    }

    property Flickable flickable;

    Toolbar {
        id: toolbar;
        //anchors.top: (settings.toolbarBottom) ? undefined : parent.top;
        //anchors.bottom: (settings.toolbarBottom) ? parent.bottom : undefined;
    }

    GalleryMode {
        id: galleryMode;
        //anchors.top: (settings.toolbarBottom) ? undefined : toolbar.bottom;
        //anchors.bottom: (settings.toolbarBottom) ? toolbar.top : undefined;
    }

    Behavior on opacity { FadeAnimation { duration: 30000; } }
    Behavior on height { NumberAnimation { easing.type: Easing.Linear; } }

    /*
    Connections {
        target: toolbar;

        onSearchChanged: {
            //console.debug("onSearchChanged");
            actionBar.height = childrenRect.height;
        }
    }
    */

    Connections {
        target: flickable
        onFlickingVerticallyChanged: {
            //console.debug("onFlickingVerticallyChanged, velocity=" + flickable.verticalVelocity);
            if (flickable.atYBeginning) {
                actionBar.shown = true;
            }

            if (flickable.verticalVelocity < 0) {
                actionBar.shown = true;
            }
            if (flickable.verticalVelocity > 0) {
                actionBar.shown = false;
            }
        }
    }
}
