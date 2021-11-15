import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: galleryContentDelegate;

    property Item contextMenu;
    property bool menuOpen: contextMenu != null && contextMenu.parent === galleryContentDelegate;
    property string contextLink;
    property bool savingInProgress: false;
    property int itemIndex;
    property bool isSlideshow: false;
    property int totalImages: 0;

    width: albumListView.width;
    height: galleryContainer.height;

    QtObject {
        id: internal;

        // webm = video/x-vp8, video/x-h264
        // "No decoder available for type 'video/x-vp8'
        function activateLoader() {
            //console.debug("link=",link, "; size=",size, "type=",type, "; animated=",animated, "; mp4=",mp4, "; gifv=",gifv, "; thumbnail=",thumbnail);
            imageLoader.active = false;
            videoLoader.active = false;

            if (!animated) {
                imageLoader.active = true;
            } else if (type === "video/mp4") {
                videoLoader.active = true;
            } else if (type === "image/gif") {
                imageLoader.active = true;
            } else {
                imageLoader.active = true;
            }
        }
    }

    Component.onCompleted: {
        internal.activateLoader();
    }

    MouseArea {
        enabled: drawer.open;
        anchors.fill: galleryContainer;
        onClicked: {
            drawer.open = false;
        }
    }

    Column {
        id: galleryContainer;
        anchors.left: parent.left; anchors.right: parent.right;
        height: childrenRect.height;

        Drawer {
            id: drawer;
            anchors.left: parent.left; anchors.right: parent.right;
            dock: Dock.Bottom;
            height: imageColumn.height;
            backgroundSize: parent.width / 5;

            background: Item {
                id: drawerContextMenu;
                anchors.left: parent.left; anchors.right: parent.right;
                height: childrenRect.height;

                ImageButtons {
                    id: imageButtons;
                }
            }

            foreground: Column {
                id: imageColumn;
                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; }
                height: imageTitleText.height + ((imageLoader.active) ? imageLoader.height : videoLoader.height);
                spacing: constant.paddingSmall;

                 enabled: !drawer.opened;

                Label {
                    id: imageTitleText;
                    anchors.leftMargin: constant.paddingSmall;
                    anchors.rightMargin: constant.paddingSmall;
                    wrapMode: Text.Wrap;
                    text: title;
                    font.pixelSize: constant.fontSizeNormal;
                    color: constant.colorHighlight;
                    anchors { left: parent.left; right: parent.right; }
                    visible: (title && is_album) ? true : false;
                }

                Loader {
                    id: videoLoader;

                    active: false;
                    visible: active;
                    asynchronous: true;

                    width: Screen.width;
                    height: (active) ? Math.min(vHeight * (Screen.width / vWidth), Screen.height) : 0;

                    anchors.horizontalCenter: parent.horizontalCenter;

                    sourceComponent: videoComponent;
                }

                Loader {
                    id: imageLoader;

                    active: false;
                    visible: active;
                    asynchronous: true;

                    width: Math.min(vWidth, parent.width);
                    height: (active) ? imageComponent.height : 0;

                    anchors.horizontalCenter: parent.horizontalCenter;

                    sourceComponent: imageComponent;
                }
            }
        } // Drawer

        Label {
            id: imageDescText;
            wrapMode: Text.Wrap;
            text: description;
            font.pixelSize: constant.fontSizeNormal;
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: constant.paddingSmall;
                rightMargin: constant.paddingSmall;
            }
            visible: (description) ? true : false;
            elide: Text.ElideRight;
            textFormat: Text.StyledText;
            linkColor: Theme.highlightColor;
            onLinkActivated: {
                contextLink = link;
                contextMenu = commentContextMenu.createObject(galleryContainer);
                contextMenu.open(galleryContentDelegate);
            }
        }
    }

    /*
    Label {
        id: indexLabel;
        text: "image " + (index + 1) + " of " + (galleryContentModel.total);
        font.pixelSize: Screen.sizeCategory >= Screen.Large
                         ? constant.fontSizeLarge : constant.fontSizeMedium;
        color: constant.colorHighlight;
        anchors { top: galleryContainer.bottom; right: parent.right; }
        anchors.leftMargin: constant.paddingSmall;
        anchors.rightMargin: constant.paddingSmall;
        anchors.bottomMargin: constant.paddingMedium;
        visible: (isSlideshow) ? true : false;
    }
    */

    Component {
        id: commentContextMenu;

        ImageContextMenu {
            url: contextLink;
        }
    }

    ImageComponent { id: imageComponent; }
    VideoComponent { id: videoComponent; }
}
