import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: galleryPage;

    property string albumTitle : "";

    property string account_url;
    property string views;
    property string ups;
    property string downs;
    property string score;
    property string images_count;
    property int upsPercent;
    property int downsPercent;
    property bool is_album: false;
    property string galleryPageTitle : "Sailimgur";

    property bool prevEnabled: currentIndex > 0 || page > 0;

    ListModel {
        id: albumImagesModel;
    }
    ListModel {
        id: albumImagesMoreModel;
    }

    ListModel {
        id: commentsModel;
    }

    signal load();

    onLoad: {
        //console.log("galleryPage.onLoad: total=" + galleryModel.count + ", currentIndex=" + currentIndex);
        albumTitle = galleryModel.get(currentIndex).title;
        if (galleryModel.get(currentIndex).is_album) {
            galleryPageTitle = qsTr("Gallery album");
            Imgur.getAlbum(galleryModel.get(currentIndex).id);
        } else {
            galleryPageTitle = qsTr("Gallery image");
            Imgur.getGalleryImage(galleryModel.get(currentIndex).id);
        }
        if (settings.showComments) {
            Imgur.getAlbumComments(galleryModel.get(currentIndex).id);
        }
        setPrevButton();
        galleryFlickable.scrollToTop();
    }

    function setPrevButton() {
        if (currentIndex === 0 && page === 0) {
            prevEnabled = false;
        } else {
            prevEnabled = true;
        }
    }

    SilicaFlickable {
        id: galleryFlickable;

        PageHeader { id: header; title: galleryPageTitle; }

        /*
        PullDownMenu {
            id: pullDownMenu

            MenuItem {

            }
        }
        */

        /*
        PushUpMenu {
            id: pushUpMenu;

            MenuItem {
                text: qsTr("To top");
                onClicked: albumListView.scrollToTop();
            }
        }
        */

        anchors.fill: parent;
        contentHeight: contentArea.height;

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right;}
            height: childrenRect.height;

            anchors.leftMargin: Theme.paddingSmall;
            anchors.rightMargin: Theme.paddingSmall;

            Label {
                id: titleText;
                anchors { left: parent.left; right: parent.right; }
                wrapMode: Text.Wrap;
                font.pixelSize: Theme.fontSizeExtraSmall;
                text: albumTitle;
            }

            Column {
                id: galleryColumn;
                anchors { left: parent.left; right: parent.right; }
                height: albumListView.height + showMoreButton.height;
                width: parent.width;

                Flow {
                    id: albumListView;
                    height: childrenRect.height;
                    width: parent.width;
                    clip: true;

                    Repeater {
                        model: albumImagesModel;

                        delegate: GalleryDelegate {
                            id: galleryDelegate;
                        }
                    }
                }
                Item {
                    id: showMoreItem;
                    width: parent.width;
                    height: visible ? showMoreButton.height + 2 * Theme.paddingSmall : 0;
                    visible: albumImagesMoreModel.count > 0;

                    Button {
                        id: showMoreButton;
                        anchors.centerIn: parent;
                        enabled: albumImagesMoreModel.count > 0;
                        text: qsTr("show more");
                        onClicked: {
                            // @Hack, better way to combine models?
                            for(var i=0; i < albumImagesMoreModel.count; i++) {
                                albumImagesModel.append(albumImagesMoreModel.get(i));
                            }
                            albumImagesMoreModel.clear();
                        }
                    }
                }
            } // galleryColumn

            Column {
                id: albumInfoColumn;
                anchors { left: parent.left; right: parent.right; }
                height: albumInfo.height + infoColumn.height + Theme.paddingSmall;
                spacing: Theme.paddingSmall;

                ListItem {
                    id: albumInfo;
                    anchors { left: parent.left; right: parent.right; }
                    height: childrenRect.height;

                    ListItem {
                        id: actionAndPointsItem;
                        anchors { left: parent.left; right: parent.right; }

                        ListItem {
                            id: actionButtons;
                            anchors { left: parent.left;}
                            anchors.verticalCenter: parent.verticalCenter;
                            width: 3 * 62 + 3 * Theme.paddingLarge;
                            height: 62;

                            IconButton {
                                id: likeButton;
                                icon.source: "../images/icons/like.svg";
                                onClicked: console.log("Like!");
                                enabled: false;
                                width: 62;
                                height: 62;
                                anchors { left: parent.left; }
                            }
                            IconButton {
                                id: dislikeButton;
                                icon.source: "../images/icons/dislike.svg";
                                onClicked: console.log("Dislike!");
                                enabled: false;
                                width: 62;
                                height: 62;
                                anchors { left: likeButton.right;
                                    leftMargin: Theme.paddingLarge; }
                            }
                            IconButton {
                                id: favoriteButton;
                                icon.source: "../images/icons/favorite.svg";
                                onClicked: console.log("Hearth!");
                                enabled: false;
                                width: 62;
                                height: 62;
                                anchors { left: dislikeButton.right;
                                    leftMargin: Theme.paddingLarge; rightMargin: Theme.paddingLarge; }
                            }
                        }

                        ListItem {
                            id: pointColumn;
                            width: 100;
                            anchors { top: parent.top; left: actionButtons.right; right: parent.right; }

                            Label {
                                id: scoreText;
                                anchors { left: parent.left; }
                                anchors.verticalCenter: parent.verticalCenter;
                                font.pixelSize: Theme.fontSizeExtraSmall;
                                text: score + " points";
                            }

                            Rectangle {
                                id: scoreUps;
                                anchors { left: scoreText.right; leftMargin: Theme.paddingLarge; }
                                anchors.verticalCenter: parent.verticalCenter;
                                width: 100 * (upsPercent/100);
                                height: 10;
                                color: "green";
                            }

                            Rectangle {
                                id: scoreDowns;
                                anchors { left: scoreUps.right; }
                                anchors.verticalCenter: parent.verticalCenter;
                                width: 100 * (downsPercent/100);
                                height: 10;
                                color: "red";
                            }
                        }
                    }

                    Column {
                        id: infoColumn;
                        anchors { top: actionAndPointsItem.bottom; left: parent.left; right: parent.right; }
                        height: childrenRect.height;

                        Label {
                            id: infoText;
                            anchors { left: parent.left; right: parent.right; }
                            wrapMode: Text.Wrap;
                            font.pixelSize: Theme.fontSizeExtraSmall;
                            text: "by " + account_url + ", " + views + " views";
                        }
                   }
                }
            } // albumInfoColumn

            Column {
                id: commentsColumn;
                anchors { left: parent.left; right: parent.right; }
                height: childrenRect.height + showCommentsItem.height + 200;
                width: parent.width;

                Item {
                    id: showCommentsItem;
                    width: parent.width
                    height: visible ? showCommentsButton.height + 2 * Theme.paddingSmall : 0;
                    visible: commentsModel.count == 0;

                    Button {
                        id: showCommentsButton;
                        anchors.centerIn: parent;
                        text: qsTr("show comments");
                        onClicked: {
                            if(commentsModel.count > 0) {
                                commentsColumn.visible = true;
                            } else {
                                Imgur.getAlbumComments(galleryModel.get(currentIndex).id);
                                commentsColumn.visible = true;
                            }
                        }
                    }
                }

                SilicaListView {
                    id: commentListView;
                    model: commentsModel;
                    height: childrenRect.height;
                    width: parent.width;
                    spacing: Theme.paddingSmall;
                    clip: true;
                    visible: commentsModel.count > 0;

                    delegate: Loader {
                        id: commentsLoader;
                        width: ListView.view.width;

                        sourceComponent: CommentDelegate {
                            id: commentDelegate;
                        }
                    }
                }
            } // commentsColumn

            Item {
                id: loadingRectComments;
                anchors.centerIn: commentsColumn;
                anchors.horizontalCenter: parent.horizontalCenter;
                visible: false;
                z: 2;

                BusyIndicator {
                    anchors.centerIn: parent;
                    visible: loadingRectComments.visible;
                    running: visible;
                    size: BusyIndicatorSize.Medium;
                    Behavior on opacity { FadeAnimation {} }
                }
            }
        }
    }

    GalleryNavigation {
        id: galleryNavigation;
    }

    Component.onCompleted: {
        albumImagesModel.clear();
        commentsModel.clear();
    }
}
