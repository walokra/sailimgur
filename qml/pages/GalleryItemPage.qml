import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: root;
    allowedOrientations: Orientation.All;

    property bool is_album: false;
    property bool is_gallery: true;
    property string imgur_id : "";

    property string galleryContentPageTitle : constant.appName;

    GalleryContentModel {
        id: galleryContentModel;
        isSlideshow: true;
    }

    signal load();

    onLoad: {
        //console.debug("galleryItemPage.onLoad: total=" + galleryContentModel.count + ", currentIndex=" + currentIndex);
        galleryContentModel.resetVariables();
        galleryContentModel.clear();

        if (galleryModel) {
            imgur_id = galleryModel.get(currentIndex).id;
            is_album = galleryModel.get(currentIndex).is_album;
            is_gallery = galleryModel.get(currentIndex).is_gallery;
        }

        if (is_album == true) {
            //galleryContentPageTitle = (is_gallery == true) ? qsTr("Gallery album's image") : qsTr("Album's image");
            galleryContentPageTitle = galleryModel.get(currentIndex).title;
            galleryContentModel.getAlbum(imgur_id, is_gallery);
        }
    }

    SilicaFlickable {
        id: flickable;

        PageHeader { id: header; title: galleryContentPageTitle; }

        anchors.fill: parent;
        clip: true;

        SilicaListView {
            id: albumListView;
            anchors { top: header.bottom; left: parent.left; right: parent.right; }
            width: parent.width;
            height: childrenRect.height;

            snapMode: ListView.SnapOneItem;
            orientation: ListView.VerticalFlick;
            highlightRangeMode: ListView.StrictlyEnforceRange;
            cacheBuffer: parent.height;
            clip: true;

            model: galleryContentModel;

            delegate: Loader {
                //asynchronous: false;

                sourceComponent: GalleryContentDelegate {
                    id: galleryContentDelegate;
                    isSlideshow: true;
                }
            }
        }

        VerticalScrollDecorator { flickable: flickable; }
   }

    Component.onCompleted: {
        load();
    }
}
