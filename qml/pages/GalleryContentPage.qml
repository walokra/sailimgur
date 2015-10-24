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
    signal removedFromModel(string imgur_id);
    signal ggpStatusChanged(int ggpStatus);

    onStatusChanged: {
        if (status === PageStatus.Deactivating) {
            // VideoComponent is listening, stopping player and destroying video on deactivation
            ggpStatusChanged(status);
        }
    }

    onLoad: {     
        //console.log("galleryContentPage.onLoad: total=" + galleryContentModel.count + ", currentIndex=" + currentIndex);
        galleryContentModel.resetVariables();
        galleryContentModel.clear();
        commentsModel.resetVariables();
        commentsModel.clear();
        loadingRectComments.visible = false;

        if (galleryModel) {
            imgur_id = galleryModel.get(currentIndex).id;
            is_album = galleryModel.get(currentIndex).is_album;
            is_gallery = galleryModel.get(currentIndex).is_gallery;
        }

        if (is_album == true) {
            galleryContentPageTitle = (is_gallery == true) ? qsTr("Gallery album") : qsTr("Album");
            galleryContentModel.getAlbum(imgur_id, is_gallery);
        } else {
            galleryContentPageTitle = (is_gallery == true) ? qsTr("Gallery image") : qsTr("Image");
            galleryContentModel.getImage(imgur_id, is_gallery);
        }

        if (settings.showComments && is_gallery == true) {
            loadingRectComments.visible = true;
            commentsModel.getComments(imgur_id);
        }

        setPrevButton();
        flickable.scrollToTop();


    }

    onRemovedFromModel: {
        galleryModel.remove(currentIndex);
        galleryContentPage.backNavigation = true;
        pageStack.pop(PageStackAction.Animated);
    }

    function setPrevButton() {
        if (currentIndex === 0 && page === 0) {
            prevEnabled = false;
        } else {
            prevEnabled = true;
        }
    }

    SilicaFlickable {
        id: flickable;
        // pressDelay: 0; // can't set this as there's Drawer

        PageHeader { id: header; title: galleryContentPageTitle; }

        PullDownMenu {
            id: pullDownMenu;

            MenuItem {
                id: imageInfoAction;
                text: qsTr("image info");
                visible: is_gallery == false;
                onClicked: {

                }
            }

            MenuItem {
                id: submitToGalleryAction;
                text: qsTr("Submit to gallery");
                visible: is_gallery == false;
                onClicked: {
                    Imgur.submitToGallery(imgur_id, title,
                        function(data){
                            console.log("Submitted to gallery. " + data);
                            infoBanner.showText(qsTr("Image submitted to gallery"));
                        },
                        function onFailure(status, statusText) {
                            infoBanner.showHttpError(status, statusText);
                        }
                    );
                }
            }

            /*
            MenuItem {
                id: deleteAction;
                text: qsTr("Delete image/album");
                visible: is_gallery == false;
                onClicked: {
                    deleteImageAlbum();
                }
            }*/

            MenuItem {
                text: qsTr("Open in external browser");
                onClicked: {
                    Qt.openUrlExternally(galleryContentModel.gallery_page_link);
                }
            }

            MenuItem {
                anchors { left: parent.left; right: parent.right; }
                text: qsTr("Copy link to clipboard");
                onClicked: {
                    Clipboard.text = galleryContentModel.gallery_page_link;
                    infoBanner.showText(qsTr("Link " + Clipboard.text + " copied to clipboard."));
                }
            }

            MenuItem {
                text: qsTr("Open page in browser");
                onClicked: {
                    var props = {
                        "url": galleryContentModel.gallery_page_link
                    }
                    pageStack.push(Qt.resolvedUrl("WebPage.qml"), props);
                }
            }

        } // Pulldown menu

        anchors.fill: parent;
        contentHeight: contentArea.height + galleryNavigation.height + albumMetaRow.height + 2 * constant.paddingMedium;
        clip: true;

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right;}
            height: childrenRect.height;
            spacing: constant.paddingMedium;

            // Shown if not in gallery, like user's albums/images
            UploadedDelegate {
                id: uploadedDelegate;
                width: parent.width;
                show_item: is_gallery == false;
                show_extra: false;
                item_is_album: is_album;
                item_title: galleryContentModel.title;
                item_imgur_id: galleryContentModel.imgur_id;
                item_link: galleryContentModel.link;
                item_deletehash: galleryContentModel.deletehash;
                item_datetime: galleryContentModel.datetime;
                parent_item: contentArea;
            }

            Separator {
                id: linkSep;
                anchors { left: parent.left; right: parent.right; }
                anchors.bottomMargin: constant.paddingLarge;
                color: constant.colorSecondary;
                visible: is_gallery == false;
            }

            Label {
                id: titleText;
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingSmall;
                anchors.rightMargin: constant.paddingSmall;

                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeLarge : constant.fontSizeMedium;
                color: constant.colorHighlight;
                text: galleryContentModel.title;
            }
            Label {
                id: descText;
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingSmall;
                anchors.rightMargin: constant.paddingSmall;

                wrapMode: Text.Wrap;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeMedium : constant.fontSizeSmall;
                color: constant.colorHighlight;
                text: galleryContentModel.description;
                visible: is_gallery == false;
            }

            Column {
                id: galleryContentColumn;
                anchors { left: parent.left; right: parent.right; }

                height: (showMoreItem.visible || showPrevItem.visible ) ? albumListView.height + showMoreButton.height + showPrevButton.height : albumListView.height;
                width: parent.width;

                Item {
                    id: showPrevItem;
                    width: parent.width;
                    height: visible ? showPrevButton.height + 2 * constant.paddingSmall : 0;
                    visible: galleryContentModel.prev > 0;

                    Button {
                        id: showPrevButton;
                        anchors.centerIn: parent;
                        enabled: galleryContentModel.prev > 0;
                        text: qsTr("show previous (" + galleryContentModel.prev + " remaining)");
                        onClicked: {
                            galleryContentModel.getPrevImages();
                        }
                    }
                }

                Flow {
                    id: albumListView;
                    height: childrenRect.height;
                    width: parent.width;
                    clip: true;

                    Repeater {
                        id: repeater;
                        model: galleryContentModel;

                        delegate: Loader {
                            asynchronous: true;

                            sourceComponent: GalleryContentDelegate {
                                id: galleryContentDelegate;
                                itemIndex: index;
                            }
                        }
                    }
                }

                Item {
                    id: showMoreItem;
                    width: parent.width;
                    height: visible ? showMoreButton.height + 2 * constant.paddingSmall : 0;
                    visible: galleryContentModel.left > 0;

                    Button {
                        id: showMoreButton;
                        anchors.centerIn: parent;
                        enabled: galleryContentModel.left > 0;
                        text: qsTr("show more (" + galleryContentModel.total + " total, " + galleryContentModel.left + " remaining)");
                        onClicked: {
                            if (settings.useGalleryPage) {
                                pageStack.push(Qt.resolvedUrl("GalleryItemPage.qml"));
                            } else {
                                galleryContentModel.getNextImages();
                            }
                        }
                    }
                }
            } // galleryContentColumn

            Item {
                id: pointColumn;
                anchors.topMargin: constant.paddingMedium;
                anchors { left: parent.left; right: parent.right; leftMargin: constant.paddingMedium; }
                height: scoreText.height + scoreBars.height + infoText.height + ((writeCommentField.visible) ? writeCommentField.height : 0);

                Label {
                    id: scoreText;
                    anchors { left: parent.left; }
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeXSmall : constant.fontSizeXXSmall;
                    text: galleryContentModel.score + " points";
                    color: constant.colorHighlight;
                }

                ListItem {
                    id: scoreBars;
                    anchors { left: parent.left; }
                    height: childrenRect.height;

                    Rectangle {
                        id: scoreUps;
                        anchors { left: parent.left; }
                        anchors.verticalCenter: parent.verticalCenter;
                        width: 100 * (galleryContentModel.upsPercent/100);
                        height: 10;
                        color: "green";
                    }

                    Rectangle {
                        id: scoreDowns;
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors { left: scoreUps.right; }
                        width: 100 * (galleryContentModel.downsPercent/100);
                        height: 10;
                        color: "red";
                    }

                    IconButton {
                        id: replyButton;
                        anchors { right: parent.right; rightMargin: constant.paddingMedium; }
                        anchors.verticalCenter: parent.verticalCenter;
                        enabled: loggedIn;
                        //width: 48;
                        //height: 48;
                        icon.width: Theme.itemSizeExtraSmall;
                        icon.height: Theme.itemSizeExtraSmall;
                        icon.source: constant.iconComments;
                        onClicked: {
                            if (writeCommentField.visible) {
                                writeCommentField.visible = false;
                            } else {
                                writeCommentField.visible = true;
                            }
                        }
                    }
                }

                Label {
                    id: infoText;
                    anchors { top: scoreBars.bottom; left: parent.left; leftMargin: constant.paddingMedium; }
                    wrapMode: Text.Wrap;
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeXSmall : constant.fontSizeXXSmall;
                    color: constant.colorHighlight;
                    text: galleryContentModel.info;
                }

                TextArea {
                    id: writeCommentField;
                    anchors { top: infoText.bottom; left: parent.left; right: parent.right; }
                    anchors.topMargin: constant.paddingMedium;
                    visible: false;
                    placeholderText: qsTr("Write comment");

                    EnterKey.enabled: text.trim().length > 0;
                    EnterKey.iconSource: "image://theme/icon-m-enter-accept";
                    EnterKey.onClicked: {
                        //console.log("Comment: " + text);
                        Imgur.commentCreation(imgur_id, text, null,
                              function (data) {
                                  //console.log("data: " + JSON.stringify(data));
                                  infoBanner.showText(qsTr("Comment sent!"));
                                  visible = false;
                                  text = "";
                                  writeCommentField.focus = false;

                                  commentsModel.getComments(imgur_id);
                              },
                              function(status, statusText) {
                                  infoBanner.showHttpError(status, statusText);
                              }
                        );
                    }
                }
            }

            Column {
                id: commentsColumn;
                anchors { left: parent.left; right: parent.right; }
                anchors.leftMargin: constant.paddingSmall;
                anchors.rightMargin: constant.paddingSmall;
                height: childrenRect.height + showCommentsItem.height + galleryNavigation.height + constant.paddingMedium;
                width: parent.width;
                visible: is_gallery == true;

                Item {
                    id: showCommentsItem;
                    width: parent.width
                    height: visible ? showCommentsButton.height : 0;
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

                    anchors.leftMargin: constant.paddingSmall;
                    anchors.rightMargin: constant.paddingSmall;

                    pressDelay: 0;
                    interactive: true;
                    boundsBehavior: Flickable.StopAtBounds;

                    delegate: Loader {
                        id: commentsLoader;
                        asynchronous: true;

                        sourceComponent: CommentDelegate {
                            id: commentDelegate;
                            width: commentListView.width
                        }
                    }

// Doesn't seem to work anymore sfos >= 1.1.9.28
//                    onMovementEnded: {
//                        console.log("onMovementEnded, atYEnd=", atYEnd)
//                        if(atYEnd) {
//                            commentsModel.getNextComments();
//                        }
//                    }
                }

                Item {
                    id: showMoreCommentsItem;
                    width: parent.width;
                    height: visible ? showMoreCommentsButton.height + 2 * constant.paddingSmall : 0;
                    visible: commentsModel.left > 0;

                    Button {
                        id: showMoreCommentsButton;
                        anchors.centerIn: parent;
                        enabled: commentsModel.left > 0;
                        text: qsTr("more (" + commentsModel.total + " total, " + commentsModel.left + " remaining)");
                        onClicked: {
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

            // Shown if not in gallery, like user's albums/images
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
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeSmall : constant.fontSizeXSmall;
                    color: constant.colorHighlight;
                    text: galleryContentModel.datetime;
                }
                Label {
                    id: viewsText;
                    width: parent.width / 2;
                    wrapMode: Text.Wrap;
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeSmall : constant.fontSizeXSmall;
                    color: constant.colorHighlight;
                    text: qsTr("views") + ": " + galleryContentModel.views;
                }
            }
        }
        VerticalScrollDecorator { flickable: flickable; }
    }

    AlbumInfoColumn {
        id: albumInfoColumn;
    }

    GalleryNavigation {
        id: galleryNavigation;
    }

    Component.onCompleted: {
        load();
    }

}
