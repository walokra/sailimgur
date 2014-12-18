import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: galleryContentDelegate;

    property Item contextMenu;
    property bool menuOpen: contextMenu != null && contextMenu.parent === galleryContentDelegate;
    property string contextLink;
    property bool savingInProgress: false;

    width: albumListView.width;
    height: menuOpen ? contextMenu.height + galleryContent.height : galleryContent.height;

    Component.onCompleted: {
        //console.debug("type=" + type + "; mp4=" + mp4 +"; gifv=" + gifv + "; webm="+webm);
        //console.debug("vWidth=" + vWidth + "; vHeight="+vHeight)
        if (animated === false) {
            imageLoader.active = true;
        } else if (type === "image/gif" && mp4 !== "") {
            videoLoader.active = true;
        } else {
            imageLoader.active = true;
        }
    }

    ListItem {
        id: galleryContent;
        width: parent.width;
        contentHeight: galleryContainer.height + 2 * constant.paddingMedium;
        //clip: true;

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
                dock: page.isPortrait ? Dock.Top : Dock.Left;
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
                    //height: childrenRect.height;
                    spacing: constant.paddingSmall;

                    enabled: !drawer.opened;

                    Label {
                        id: imageTitleText;
                        anchors.leftMargin: constant.paddingSmall;
                        anchors.rightMargin: constant.paddingSmall;
                        wrapMode: Text.Wrap;
                        text: title;
                        font.pixelSize: constant.fontSizeXSmall;
                        color: constant.colorHighlight;
                        anchors { left: parent.left; right: parent.right; }
                        visible: (title && is_album) ? true : false;
                    }

                    Loader {
                        id: videoLoader;

                        anchors.horizontalCenter: parent.horizontalCenter;

                        width: Math.min(vWidth, parent.width);
                        height: (active) ? videoComponent.height : 0;

                        active: false;
                        visible: active;
                        asynchronous: true;
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
                font.pixelSize: constant.fontSizeXSmall;
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingSmall;
                anchors.rightMargin: constant.paddingSmall;
                visible: (description) ? true : false;
                elide: Text.ElideRight;
                textFormat: Text.StyledText;
                linkColor: Theme.highlightColor;
                onLinkActivated: {
                    //console.log("Link clicked! " + link);
                    contextLink = link;
                    contextMenu = commentContextMenu.createObject(galleryContent);
                    contextMenu.show(galleryContentDelegate);
                }
            }
        }
    } // galleryContent

    Component {
        id: commentContextMenu;

        ImageContextMenu {
            url: contextLink;
        }
    }

    ImageComponent { id: imageComponent; }
    VideoComponent { id: videoComponent; }
}
