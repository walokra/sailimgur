import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Row {
    property var model
    spacing: 0

    width: parent.width
    height: prevButton.height + 2*Theme.paddingSmall

    visible: (prevButton.enabled || nextButton.enabled) && model.total > 1

    Button {
        id: prevButton
        width: parent.width/2
        enabled: model.prev > 0
        text: enabled ? qsTr(String("previous (%1 left)").arg(model.prev ? model.prev : 0)) : "previous"

        onClicked: {
            model.getPrevImages();
        }
    }

    Button {
        id: nextButton
        width: parent.width/2
        enabled: model.left > 0
        text: enabled ? qsTr(String("next (%2/%1 left)").arg(model.total ? model.total : 0).arg(model.left ? model.left : 0)) : "next"

        onClicked: {
            if (settings.useGalleryPage) {
                pageStack.push(Qt.resolvedUrl("GalleryItemPage.qml"));
            } else {
                model.getNextImages();
            }
        }
    }
}
