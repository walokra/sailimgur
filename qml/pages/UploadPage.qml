import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur
import harbour.sailimgur.Uploader 1.0

Page {
    id: uploadPage;
    allowedOrientations: Orientation.All;

    property string imagePath: "";
    property bool submitToGallery: false;

    Connections{
        target: imageUploader
        onProgressChanged: {
            uploadProgress.value = percentage;
            if (percentage === 100) {
                uploadProgress.visible=false;
            }
        }
    }

    SilicaFlickable {
        id: uploadFlickable;

        anchors.fill: parent;
        contentHeight: contentArea.height;

        PageHeader {
            id: header;
            title: qsTr("Upload image");
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
                    enabled: true;
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
            }

            Separator {
                id: drawerSep;
                anchors { left: parent.left; right: parent.right; }
                color: constant.colorSecondary;
                primaryColor: Theme.rgba(color, 0.5)
                secondaryColor: Theme.rgba(color, 0.5)
            }

            TextField {
                id: titleTextField;
                width: parent.width;
                placeholderText: qsTr("Title");
                label: qsTr("Title");
            }

            TextField {
                id: descTextField;
                width: parent.width;
                placeholderText: qsTr("Description");
                label: qsTr("Description");
            }

            ListItem {
                TextSwitch {
                    text: qsTr("Add to gallery");
                    onCheckedChanged: {
                        checked ? submitToGallery = true : submitToGallery = false;
                    }
                }

                /*
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
                */
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

            ListItem {
                Button {
                    id: uploadButton;
                    anchors { left: parent.left; }
                    width: parent.width / 2;
                    text: qsTr("Start upload");
                    enabled: imagePath != '';
                    onClicked: {
                        imageUploadData.uploadImage(imagePath, "xvjOS", titleTextField.text, descTextField.text);
                    }
                }
                Button {
                    id: removeButton;
                    anchors { left: uploadButton.right; right: parent.right; }
                    width: parent.width / 2;
                    text: qsTr("Clear image");
                    enabled: imagePath != '';
                    onClicked: {
                        imagePath = "";
                    }
                }
            }

            ProgressBar {
                id: uploadProgress;
                minimumValue: 0;
                maximumValue: 100;
                value: 0;
                anchors { left: parent.left; right: parent.right; }
                visible: false;
            }
        }

        VerticalScrollDecorator { flickable: uploadFlickable; }
    }

    ImageUploader {
        id: imageUploader

        onSuccess: {
            console.log(JSON.stringify(replyData));
            imageUploadData.onSuccess(JSON.stringify(replyData));
        }

        onFailure: {
            console.log(status, statusText);
            imageUploadData.onFailure(status, statusText)
        }

        function run() {
            imageUploader.setFile(imageUploadData.imagePath);
            imageUploader.setParameters(imageUploadData.imageAlbum, imageUploadData.imageTitle, imageUploadData.imageDesc);

            imageUploader.setAuthorizationHeader(Imgur.getAuthorizationHeader());
            imageUploader.setUserAgent(constant.userAgent);

            imageUploader.upload()
        }
    }

    QtObject {
        id: imageUploadData
        property string imagePath : "";
        property string imageAlbum : "";
        property string imageTitle : "";
        property string imageDesc : "";

        /*
        Image Upload
        Upload a new image.
        Method	POST
        Route	https://api.imgur.com/3/image
        Alternative Route	https://api.imgur.com/3/upload
        Response Model	Basic

        Parameters
        Key	Required	Description
        image	required	A binary file, base64 data, or a URL for an image
        album	optional    The id of the album you want to add the image to. For anonymous albums, {album} should be the deletehash that is returned at creation.
        type	optional	The type of the file that's being sent; file, base64 or URL
        name	optional	The name of the file, this is automatically detected if uploading a file with a POST and multipart / form-data
        title	optional	The title of the image.
        description	optional	The description of the image.
        */
        function uploadImage(image, album, title, desc) {
            imagePath = image;
            imageAlbum = album;
            imageTitle = title;
            imageDesc = desc;

            if (imagePath != '') {
                imageUploader.run();
            }
        }

        function onSuccess(data) {
            infoBanner.showText(qsTr("Image uploaded successfully"));

            if (submitToGallery) {
                Imgur.submitToGallery(data.id, imageTitle,
                    function(data){
                        console.log("Submitted to gallery. " + data);
                        infoBanner.showText(qsTr("Image submitted to gallery"));
                    },
                    onFailure
                );
            }

            imageAlbum = "";
            imagePath = "";
            uploadPage.imagePath = "";
            imageTitle = "";
            titleTextField.text = "";
            imageDesc = "";
            descTextField.text = "";
        }

        function onFailure(status, statusText) {
            infoBanner.showHttpError(status, statusText);
        }
    }

    Component.onCompleted: {
    }
}
