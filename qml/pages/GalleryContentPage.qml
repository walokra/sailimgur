import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: galleryContentPage;
    allowedOrientations: Orientation.All;

    property bool is_album: false;
    property bool is_gallery: true;
    property string imgur_id : "";

    property string galleryContentPageTitle : constant.appName;

    property bool prevEnabled: currentIndex > 0 || page > 0;

    GalleryContentModel {
        id: galleryContentModel;
    }

    CommentsModel {
        id: commentsModel;
    }

    signal load();

    onLoad: {
        //console.log("galleryContentPage.onLoad: total=" + galleryContentModel.count + ", currentIndex=" + currentIndex);
        galleryContentModel.clear();
        galleryContentModel.index = 0;
        galleryContentModel.allImages = [];
        commentsModel.clear();
        commentsModel.index = 0;
        commentsModel.allComments = [];

        imgur_id = galleryModel.get(currentIndex).id;
        is_album = galleryModel.get(currentIndex).is_album;
        is_gallery = galleryModel.get(currentIndex).is_gallery;

        if (is_album === true) {
            galleryContentPageTitle = (is_gallery == true) ? qsTr("Gallery album") : qsTr("Album");
            galleryContentModel.getAlbum(imgur_id, is_gallery);
        } else {
            galleryContentPageTitle = (is_gallery == true) ? qsTr("Gallery image") : qsTr("Image");
            showMoreItem.visible = false;
            galleryContentModel.getImage(imgur_id, is_gallery);
        }

        if (settings.showComments && is_gallery == true) {
            loadingRectComments.visible = true;
            commentsModel.getComments(imgur_id);
        }

        setPrevButton();
        galleryContentFlickable.scrollToTop();
    }

    function setPrevButton() {
        if (currentIndex === 0 && page === 0) {
            prevEnabled = false;
        } else {
            prevEnabled = true;
        }
    }

    SilicaFlickable {
        id: galleryContentFlickable;
        pressDelay: 0;

        PageHeader { id: header; title: galleryContentPageTitle; }

        anchors.fill: parent;
        contentHeight: contentArea.height + galleryNavigation.height + albumMetaRow.height + 2 * constant.paddingMedium;
        clip: true;

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right;}
            height: childrenRect.height;
            spacing: constant.paddingMedium;

            anchors.leftMargin: constant.paddingSmall;
            anchors.rightMargin: constant.paddingSmall;

            GalleryContentLink {
                id: galleryContentLink;
                link: galleryContentModel.link;
                deletehash: galleryContentModel.deletehash;
            }

            Label {
                id: titleText;
                anchors { left: parent.left; right: parent.right; }
                wrapMode: Text.Wrap;
                font.pixelSize: constant.fontSizeMedium;
                color: constant.colorHighlight;
                text: galleryContentModel.title;
            }
            Label {
                id: descText;
                anchors { left: parent.left; right: parent.right; }
                wrapMode: Text.Wrap;
                font.pixelSize: constant.fontSizeSmall;
                color: constant.colorHighlight;
                text: galleryContentModel.description;
                visible: is_gallery == false;
            }

            Column {
                id: galleryContentColumn;
                anchors { left: parent.left; right: parent.right; }
                height: (showMoreItem.visible) ? albumListView.height + showMoreButton.height : albumListView.height;
                width: parent.width;

                Flow {
                    id: albumListView;
                    height: childrenRect.height;
                    width: parent.width;
                    clip: true;

                    Repeater {
                        model: galleryContentModel;

                        delegate: Loader {
                            asynchronous: true;

                            sourceComponent: GalleryContentDelegate {
                                id: galleryContentDelegate;
                            }
                        }
                    }
                }

                Item {
                    id: showMoreItem;
                    width: parent.width;
                    height: visible ? showMoreButton.height + 2 * constant.paddingSmall : 0;

                    Button {
                        id: showMoreButton;
                        anchors.centerIn: parent;
                        enabled: galleryContentModel.count < galleryContentModel.total;
                        text: qsTr("show more (" + galleryContentModel.total + " total, " + galleryContentModel.left + " remaining)");
                        onClicked: {
                            galleryContentModel.getNextImages();
                        }
                    }
                }
            } // galleryContentColumn

            Column {
                id: albumInfoColumn;
                anchors { left: parent.left; right: parent.right; }
                height: albumInfo.height + infoColumn.height + constant.paddingSmall;
                spacing: constant.paddingSmall;
                visible: is_gallery == true;

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
                            width: 3 * 62 + 3 * constant.paddingLarge;
                            height: 62;

                            IconButton {
                                id: likeButton;
                                anchors { left: parent.left; }
                                icon.source: (galleryContentModel.vote === "up") ? constant.iconLiked : constant.iconLike;
                                enabled: loggedIn;
                                width: 62;
                                height: 62;
                                onClicked: {
                                    //console.log("Like!");
                                    Imgur.galleryVote(imgur_id, "up",
                                        function (data) {
                                            //infoBanner.showText(data);
                                            //console.log("Like success: " + vote);
                                            if (galleryContentModel.vote === "up") {
                                                galleryContentModel.vote = "";
                                            } else {
                                                galleryContentModel.vote = "up";
                                            }
                                        },
                                        function(status, statusText) {
                                            infoBanner.showHttpError(status, statusText);
                                        }
                                    );
                                }
                            }
                            IconButton {
                                id: dislikeButton;
                                anchors { left: likeButton.right; leftMargin: constant.paddingLarge; }
                                icon.source: (galleryContentModel.vote === "down") ? constant.iconDisliked : constant.iconDislike;
                                enabled: loggedIn;
                                width: 62;
                                height: 62;
                                onClicked: {
                                    //console.log("Dislike!");
                                    Imgur.galleryVote(imgur_id, "down",
                                        function (data) {
                                            //infoBanner.showText(data);
                                            //console.log("Dislike success: " + vote);
                                            if (galleryContentModel.vote === "down") {
                                                galleryContentModel.vote = "";
                                            } else {
                                                galleryContentModel.vote = "down";
                                            }
                                        },
                                        function(status, statusText) {
                                            infoBanner.showHttpError(status, statusText);
                                        }
                                    );
                                }
                            }
                            IconButton {
                                id: favoriteButton;
                                anchors { left: dislikeButton.right; leftMargin: constant.paddingLarge; rightMargin: constant.paddingLarge; }
                                icon.source: (galleryContentModel.favorite) ? constant.iconFavorited : constant.iconFavorite;
                                enabled: loggedIn;
                                width: 62;
                                height: 62;
                                onClicked: {
                                    //console.log("Hearth!");
                                    if (is_album) {
                                        Imgur.albumFavorite(imgur_id,
                                            function (data) {
                                                //console.log("data: " + data);
                                                //infoBanner.showText(data);
                                                if (data === "favorited") {
                                                   galleryContentModel.favorite = true;
                                                } else if (data === "unfavorited") {
                                                    galleryContentModel.favorite = false;
                                                }
                                            },
                                            function(status, statusText) {
                                                infoBanner.showHttpError(status, statusText);
                                            }
                                        );
                                    }
                                    else {
                                        Imgur.imageFavorite(imgur_id,
                                            function (data) {
                                                //console.log("data: " + data);
                                                //infoBanner.showText(data);
                                                if (data === "favorited") {
                                                   galleryContentModel.favorite = true;
                                                } else if (data === "unfavorited") {
                                                    galleryContentModel.favorite = false;
                                                }
                                            },
                                            function(status, statusText) {
                                                infoBanner.showHttpError(status, statusText);
                                            }
                                        );
                                    }
                                }
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
                                font.pixelSize: constant.fontSizeXSmall;
                                text: galleryContentModel.score + " points";
                                color: constant.colorHighlight;
                            }

                            Rectangle {
                                id: scoreUps;
                                anchors { left: scoreText.right; leftMargin: constant.paddingLarge; }
                                anchors.verticalCenter: parent.verticalCenter;
                                width: 100 * (galleryContentModel.upsPercent/100);
                                height: 10;
                                color: "green";
                            }

                            Rectangle {
                                id: scoreDowns;
                                anchors { left: scoreUps.right; }
                                anchors.verticalCenter: parent.verticalCenter;
                                width: 100 * (galleryContentModel.downsPercent/100);
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
                            font.pixelSize: constant.fontSizeXSmall;
                            color: constant.colorHighlight;
                            text: qsTr("by") + " " + galleryContentModel.account_url + ", " + galleryContentModel.views + " " + qsTr("views");
                        }
                   }
                }
            } // albumInfoColumn

            Column {
                id: commentsColumn;
                anchors { left: parent.left; right: parent.right; }
                height: childrenRect.height + showCommentsItem.height + galleryNavigation.height + constant.paddingMedium;
                width: parent.width;
                visible: is_gallery == true;

                Item {
                    id: showCommentsItem;
                    width: parent.width
                    height: visible ? showCommentsButton.height + 2 * constant.paddingSmall : 0;
                    visible: commentsModel.count == 0;

                    Button {
                        id: showCommentsButton;
                        anchors.centerIn: parent;
                        text: qsTr("show comments");
                        onClicked: {
                            //console.log("commentsModel.count: " + commentsModel.count);
                            if(commentsModel.count > 0) {
                                commentsColumn.visible = true;
                            } else {
                                loadingRectComments.visible = true;
                                commentsModel.getComments(imgur_id);
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
                    spacing: constant.paddingSmall;
                    clip: true;
                    visible: commentsModel.count > 0;

                    pressDelay: 0;
                    interactive: true;
                    boundsBehavior: Flickable.StopAtBounds;

                    delegate: Loader {
                        id: commentsLoader;
                        asynchronous: true;

                        sourceComponent: CommentDelegate {
                            id: commentDelegate;
                        }
                    }

                    onMovementEnded: {
                        if(atYEnd) {
                            commentsModel.getNextComments();
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

            Row {
                id: albumMetaRow;
                anchors { left: parent.left; right: parent.right; }
                width: parent.width;
                z: 1;
                anchors.leftMargin: constant.paddingMedium;
                anchors.rightMargin: constant.paddingMedium;
                visible: is_gallery == false;

                Label {
                    id: datetimeText;
                    width: parent.width / 2;
                    wrapMode: Text.Wrap;
                    font.pixelSize: constant.fontSizeXSmall;
                    color: constant.colorHighlight;
                    text: galleryContentModel.datetime;
                }
                Label {
                    id: viewsText;
                    width: parent.width / 2;
                    wrapMode: Text.Wrap;
                    font.pixelSize: constant.fontSizeXSmall;
                    color: constant.colorHighlight;
                    text: " : " + galleryContentModel.views + " " + qsTr("views");
                }
            }
        }
        VerticalScrollDecorator { flickable: galleryContentFlickable; }
    }

    GalleryNavigation {
        id: galleryNavigation;
    }

    Component.onCompleted: {
        galleryContentModel.clear();
        commentsModel.clear();
        commentsModel.allComments = [];
    }

}
