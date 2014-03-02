import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: uploadPage;
    allowedOrientations: Orientation.All;

    property string imagePath: "";

    SilicaFlickable {
        id: uploadFlickable;

        anchors.fill: parent;
        contentHeight: contentArea.height;

        PageHeader {
            id: header;
            title: qsTr("Upload images");
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right }
            width: uploadPage.width;
            height: childrenRect.height;

            anchors.leftMargin: constant.paddingMedium;
            anchors.rightMargin: constant.paddingMedium;

            ListItem {
                anchors { left: parent.left; right: parent.right }

                BackgroundItem {
                    id: deviceItem;
                    anchors { left: parent.left; }
                    width: parent.width / 2;

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.verticalCenter: parent.verticalCenter;
                        text: qsTr("Gallery");
                        font.pixelSize: constant.fontSizeMedium;
                        color: deviceItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                    }

                    onClicked: {
                        console.log("Sailfish.Pickers.ImagePickerPage");
                        var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage");
                        imagePicker.selectedContentChanged.connect(function() {
                            imagePath = imagePicker.selectedContent;
                        });
                    }
                }

                BackgroundItem {
                    id: cameraItem;
                    anchors { left: deviceItem.right; right: parent.right; }
                    width: parent.width / 2;
                    enabled: false;
                    opacity: 0.6;

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.verticalCenter: parent.verticalCenter;
                        text: qsTr("Camera");
                        font.pixelSize: constant.fontSizeMedium;
                        color: cameraItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                    }

                    onClicked: {
                        console.log("Sailfish.Camera");
                        var imagePicker = pageStack.push("Sailfish.Camera");
                        imagePicker.selectedContentChanged.connect(function() {
                            imagePath = imagePicker.selectedContent;
                        });
                    }
                }

                /*
                Button {
                    id: deviceItem;
                    anchors { left: parent.left; }
                    text: qsTr("Device");
                    onClicked: {
                        console.log("Sailfish.Pickers.ImagePickerPage");
                        var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage");
                        imagePicker.selectedContentChanged.connect(function() {
                            imagePath = imagePicker.selectedContent;
                        });
                    }
                }

                Button {
                    id: cameraItem;
                    anchors { left: deviceItem.right; }
                    text: qsTr("Camera");
                    onClicked: {
                        console.log("Sailfish.Camera");
                        var imagePicker = pageStack.push("Sailfish.Camera");
                        imagePicker.selectedContentChanged.connect(function() {
                            imagePath = imagePicker.selectedContent;
                        });
                    }
                }
                */
            }

            Separator {
                id: drawerSep;
                anchors { left: parent.left; right: parent.right; }
                color: constant.colorSecondary;
                primaryColor: Theme.rgba(color, 0.5)
                secondaryColor: Theme.rgba(color, 0.5)
            }

            ListItem {
                BackgroundItem {
                    id: galleryItem;
                    anchors { left: parent.left; }
                    width: parent.width / 2;
                    enabled: false;
                    opacity: 0.6;

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.verticalCenter: parent.verticalCenter;
                        text: qsTr("Add to gallery");
                        font.pixelSize: constant.fontSizeMedium;
                        color: galleryItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                    }

                    onClicked: {

                    }
                }

                BackgroundItem {
                    id: albumItem;
                    anchors { left: galleryItem.right; right: parent.right; }
                    width: parent.width / 2;
                    enabled: false;
                    opacity: 0.6;

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.verticalCenter: parent.verticalCenter;
                        text: qsTr("Create album");
                        font.pixelSize: constant.fontSizeMedium;
                        color: albumItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                    }

                    onClicked: {

                    }
                }
            }

            SectionHeader { text: qsTr("Selected image"); }

            Image {
                width: 200; height: 200;
                visible: source != '';
                fillMode: Image.PreserveAspectFit;
                anchors.horizontalCenter: parent.horizontalCenter;
                source: imagePath;
            }

            Label {
                id: imagePlaceHolder;
                width: parent.width;
                height: 200;
                visible: imagePath == '';
                text: qsTr("No image selected");
                color: constant.colorHighlight;
            }

            Button {
                id: uploadButton;
                anchors.horizontalCenter: parent.horizontalCenter;
                text: qsTr("Start upload");
                enabled: imagePath != '';
                onClicked: {
                    //uploadImage(imagePath, album, name, title, desc, onSuccess, onFailure)
                    Imgur.uploadImage(imagePath, "Test_image.jpg", "Test image", "Testing upload",
                        function() {
                        },
                        function(status, statusText){
                            infoBanner.showHttpError(status, statusText);
                        });
                }
            }
        }

        VerticalScrollDecorator { flickable: uploadFlickable; }
    }

    Component.onCompleted: {
    }
}
