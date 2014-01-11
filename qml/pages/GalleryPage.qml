import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: galleryPage;

    property string albumTitle: "";

    property string account_url;
    property string views;
    property string ups;
    property string downs;
    property string score;
    property string images_count;
    property int upsPercent;
    property int downsPercent;
    property bool is_album: false;

    property bool prevEnabled: currentIndex > 0 || page > 0;

    ListModel {
        id: albumImagesModel;
    }

    ListModel {
        id: commentsModel;
    }

    signal load();

    onLoad: {
        loadingRect.visible = true;
        //console.log("galleryPage.onLoad: total=" + galleryModel.count + ", currentIndex=" + currentIndex);
        albumTitle = galleryModel.get(currentIndex).title;
        if (galleryModel.get(currentIndex).is_album) {
            Imgur.getAlbum(galleryModel.get(currentIndex).id);
        } else {
            Imgur.getGalleryImage(galleryModel.get(currentIndex).id);
        }
        if (settings.showComments) {
            Imgur.getAlbumComments(galleryModel.get(currentIndex).id);
        }
        setPrevButton();
    }

    function setPrevButton() {
        if (currentIndex === 0 && page === 0) {
            prevEnabled = false;
        } else {
            prevEnabled = true;
        }
    }

    Rectangle {
        id: navBg;
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; }
        height: 80;
        z: 1;
        color: "black";
        opacity: 0.7;

        ListItem {
            id: navigationItem;

            Button {
                id: prev;
                text: qsTr("« Previous");

                height: Theme.itemSizeExtraSmall;
                anchors.left: parent.left;

                onClicked: {
                    //console.log("Previous clicked! curr=" + currentIndex + "; page=" + page);
                    if (currentIndex > 0 && page >= 0) {
                        currentIndex -= 1;
                        load();
                    } else if (currentIndex === 0 && page >= 1) {
                        //console.log("Getting previous list of images");
                        page -= 1;
                        currentIndex = -1;
                        Imgur.processGalleryMode(true);
                    }
                    setPrevButton();
                }
                enabled: prevEnabled;
                visible: prevEnabled;
            }

            Button {
                id: next;
                text: qsTr("Next »");

                height: Theme.itemSizeExtraSmall;
                anchors.right: parent.right;

                onClicked: {
                    //console.log("Next clicked! curr=" + currentIndex + "; model=" + galleryModel.count);
                    if (currentIndex < galleryModel.count-1) {
                        //console.log("Getting next image");
                        currentIndex += 1;
                        load();
                    }
                    prevEnabled = true;
                    if (currentIndex === galleryModel.count-1) {
                        //console.log("Getting new list of images");
                        page += 1;
                        currentIndex = 0;
                        Imgur.processGalleryMode(true);
                    }
                }
            }
        } // navigationItem
    }

    SilicaFlickable {
        id: galleryFlickable;

        PageHeader { id: header; title: "Sailimgur"; }

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
                height: albumListView.height;
                width: parent.width;

                Flow {
                    id: albumListView;
                    height: childrenRect.height;
                    width: parent.width;

                    Repeater {
                        model: albumImagesModel;

                        delegate: GalleryDelegate {
                            id: galleryDelegate;
                        }
                    }
                }
            } // galleryColumn

            Column {
                id: albumInfoColumn;
                anchors { left: parent.left; right: parent.right; }
                height: 150;
                spacing: Theme.paddingSmall;

                ListItem {
                    id: albumInfo;
                    anchors { left: parent.left; right: parent.right; }

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
                height: childrenRect.height + 200;
                width: parent.width;

                SilicaListView {
                    id: commentListView;
                    model: commentsModel;
                    height: childrenRect.height;
                    width: parent.width;
                    spacing: Theme.paddingSmall;

                    delegate: CommentDelegate {
                        id: commentDelegate;
                    }
                }

            } // commentsColumn
        }
    }

    Component.onCompleted: {
        albumImagesModel.clear();
        commentsModel.clear();
    }
}
