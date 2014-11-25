import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root;
    anchors { left: parent.left; right: parent.right; }
    z: 1;
    visible: true;
    height: toolbar.height  + galleryMode.height;

    property bool shown: true;
    property alias toolbar: toolbar;
    property alias galleryMode: galleryMode;

    Connections {
        target: settingsDialog;
        onToolbarPositionChanged: {
            //console.debug("actionBar.onToolbarPositionChanged");
            toolbar.state = "reanchored";
            galleryMode.state = "reanchored";
        }
    }

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

        states:
            State {
                name: "reanchored"

                AnchorChanges {
                    target: toolbar;
                    anchors.top: (settings.toolbarBottom) ? undefined : parent.top;
                    anchors.bottom: (settings.toolbarBottom) ? parent.bottom : undefined;
                }
            }

        function setAnchors() {
            console.debug("toolbar.setAnchors");
            if (settings.toolbarBottom) {
                anchors.top = undefined;
                anchors.bottom = parent.bottom;
            } else {
                anchors.bottom = undefined;
                anchors.top = parent.top;
            }
        }
    }

    GalleryMode {
        id: galleryMode;

        states:
            State {
                name: "reanchored"

                AnchorChanges {
                    target: galleryMode;
                    anchors.top: (settings.toolbarBottom) ? undefined : toolbar.bottom;
                    anchors.bottom: (settings.toolbarBottom) ? toolbar.top : undefined;
                }
            }

        function setAnchors() {
            console.debug("toolbar.setAnchors");
            if (settings.toolbarBottom) {
                anchors.top = undefined;
                anchors.bottom = toolbar.bottom;
            } else {
                anchors.bottom = undefined;
                anchors.top = toolbar.bottom;
            }
        }
    }

    Behavior on opacity { FadeAnimation { duration: 10000; } }
    Behavior on height { NumberAnimation { easing.type: Easing.Linear; } }

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

    Component.onCompleted: {
        toolbar.setAnchors();
        galleryMode.setAnchors();
    }
}
