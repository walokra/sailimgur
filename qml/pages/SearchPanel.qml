import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root;

    anchors { left: parent.left; right: parent.right }
    height: childrenRect.height

    SearchField {
        id: searchTextField;
        anchors { left: parent.left; right: parent.right }
        labelVisible: false;
        text: galleryModel.query;

        EnterKey.enabled: text.trim().length > 0;
        EnterKey.iconSource: "image://theme/icon-m-search";
        EnterKey.onClicked: {
            internal.search(searchTextField.text);
            focus = false;
        }

        placeholderText: qsTr("Search from gallery");
    }

    QtObject {
        id: internal;

        function search(query) {
            //console.debug("Searched: " + query);
            galleryModel.query = query;
            galleryModel.clear();
            galleryModel.processGalleryMode(query);
        }
    }

}
