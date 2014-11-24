import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur
import "../components/storage.js" as Storage
import harbour.sailimgur.Uploader 1.0

Page {
    id: root;
    allowedOrientations: Orientation.All;

    signal load();

    onLoad: {
        resetFields();
        resetUploadState();
    }

    property bool submitToGallery: false;
    property string imagePath: "";
    property string imageAlbum: "";
    property bool uploadDone: false;
    property string previewSectionText: qsTr("Selected image");

    property string link;
    property string deletehash;
    property string id;
    property string title;
    property string datetime;

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
            width: parent.width;
            anchors.leftMargin: constant.paddingMedium;
            anchors.rightMargin: constant.paddingMedium;

            ListItem {
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
                        //console.log("Sailfish.Pickers.ImagePickerPage");
                        var imagePicker = pageStack.push("Sailfish.Pickers.ImagePickerPage");
                        imagePicker.selectedContentChanged.connect(function() {
                            imagePath = imagePicker.selectedContent;
                        });
                        resetUploadState();
                    }
                }

                /*
                BackgroundItem {
                    id: cameraItem;
                    anchors { left: deviceItem.right; right: parent.right; }
                    width: (parent.width / 2);
                    enabled: true;

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.verticalCenter: parent.verticalCenter;
                        text: qsTr("Camera");
                        font.pixelSize: constant.fontSizeMedium;
                        color: cameraItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                    }

                    onClicked: {
                        //console.log("Sailfish.Camera");
                        var imagePicker = pageStack.push("Sailfish.Camera");
                        imagePicker.selectedContentChanged.connect(function() {
                            imagePath = imagePicker.selectedContent;
                        });
                        resetUploadState();
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

            Item {
                height: 25;
                anchors { left: parent.left; right: parent.right; }
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

            TextSwitch {
                id: galleryItem;
                text: qsTr("Add to usersub");
                anchors { left: parent.left; right: parent.right; }
                onCheckedChanged: {
                    checked ? submitToGallery = true : submitToGallery = false;
                }
            }

            /*
            ComboBox {
                id: albumBox;
                currentIndex: 0;
                anchors { left: parent.left; right: parent.right; }
                visible: loggedIn;

                menu: ContextMenu {

                    MenuItem {
                        text: qsTr("No album selected");
                        onClicked: {
                            imageAlbum = "";
                        }
                    }
                    MenuItem {
                        text: "Test album";
                        onClicked: {
                            imageAlbum = "2izYw";
                        }
                    }

                    Repeater {
                        id: menuRepeater;
                        width: parent.width;
                        model: userAlbums;

                        delegate: MenuItem {
                            text: modelData.name
                            onClicked: {
                                imageAlbum = modelData.id;
                            }
                        }
                    }
                }
            }
            */

            SectionHeader { id: previewSection; text: previewSectionText }

            Image {
                width: 480; height: 200;
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

            UploadedDelegate {
                id: uploadedDelegate;
                width: parent.width;
                anchors { left: parent.left; right: parent.right; }

                show_item: true;
                show_extra: false;
                item_title: title;
                item_imgur_id: id;
                item_link: link;
                item_deletehash: deletehash;
                item_datetime: datetime;
                parent_item: contentArea;
            }

            Item {
                height: 25;
                anchors { left: parent.left; right: parent.right; }
                visible: uploadDone;
            }

            ListItem {
                Button {
                    id: uploadButton;
                    anchors { left: parent.left; }
                    width: parent.width / 2;
                    text: qsTr("Start upload");
                    enabled: imagePath != '';
                    onClicked: {
                        resetUploadState();
                        imageUploadData.uploadImage(imagePath, imageAlbum, titleTextField.text, descTextField.text);
                        uploadProgress.visible = true;
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
                maximumValue: 1;
                value: 0;
                anchors { left: parent.left; right: parent.right; }
                visible: false;
            }
        }

        VerticalScrollDecorator { flickable: uploadFlickable; }
    }

    ImageUploader {
        id: imageUploader

        onProgressChanged: {
            uploadProgress.value = progress;
            if (progress === 1) {
                uploadProgress.visible=false;
            }
        }

        onSuccess: {
            imageUploadData.onSuccess(replyData);
            uploadProgress.visible=false;
        }

        onFailure: {
            imageUploadData.onFailure(status, statusText);
        }

        function run() {
            imageUploader.setFile(imageUploadData.imagePath);
            imageUploader.setParameters(imageUploadData.imageAlbum, imageUploadData.imageTitle, imageUploadData.imageDesc);

            imageUploader.setAuthorizationHeader(Imgur.getAuthorizationHeader());
            imageUploader.setUserAgent(constant.userAgent);

            imageUploader.upload();
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

        function onSuccess(replyData) {
            infoBanner.showText(qsTr("Image uploaded successfully"));
            var jsonObject = JSON.parse(replyData);
            var data = jsonObject.data;

            link = data.link;
            deletehash = data.deletehash;
            id = data.id;
            title = data.title;
            datetime = data.datetime;

            uploadDone = true;
            previewSectionText = qsTr("Image uploaded");
            titleTextField.text = "";
            descTextField.text = "";

            if (submitToGallery) {
                Imgur.submitToGallery(data.id, imageTitle,
                    function(data){
                        console.log("Submitted to gallery. " + data);
                        infoBanner.showText(qsTr("Image submitted to gallery"));
                    },
                    onFailure
                );
            }

            Storage.writeUploadedImageInfo(data.id, data);
        }

        function onFailure(status, statusText) {
            infoBanner.showHttpError(status, statusText);
        }
    }

    function resetFields() {
        imagePath = "";
        imageUploadData.imageAlbum = "";
        imageUploadData.imagePath = "";
        imageUploadData.imageTitle = "";
        titleTextField.text = "";
        imageUploadData.imageDesc = "";
        descTextField.text = "";
    }

    function resetUploadState() {
        previewSectionText = qsTr("Selected image");
        link = "";
        deletehash = "";
        id = "";
        title = "";
        datetime = "";
        uploadDone = false;
    }

    Component.onCompleted: {

    }
}
