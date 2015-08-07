import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

ApplicationWindow {
    id: main;

    property Page currentPage: pageStack.currentPage

    property int page : 0;
    property int currentIndex : 0;
    property bool loggedIn : false;

    property string creditsUserRemaining : "";
    property string creditsClientRemaining : "";

    initialPage: Component {
        id: mainPage;

        MainPage {
        id: mp;
            property bool __isMainPage : true;
        }
    }

    cover: CoverPage { id: coverPage; }

    GalleryModel { id: galleryModel; }

    //GalleryContentPage{ id: galleryContentPage; }

    AboutPage { id: aboutPage; }

    SettingsDialog { id: settingsDialog; }

    Settings { id: settings; }

    Constant { id: constant; }

    SignInPage { id: signInPage; }

    UploadPage { id: uploadPage; }

    UploadedPage { id: uploadedPage; }

    AccountPage { id: accountPage; }

    Rectangle {
        id: infoBanner;
        y: Theme.paddingSmall;
        z: 1;
        width: parent.width;

        height: infoLabel.height + 2 * Theme.paddingMedium;
        color: Theme.highlightBackgroundColor;
        opacity: 0;
        visible: false;

        Label {
            id: infoLabel;
            text : ''
            font.pixelSize: Theme.fontSizeExtraSmall;
            width: parent.width - 2 * Theme.paddingSmall
            anchors.top: parent.top;
            anchors.topMargin: Theme.paddingMedium;
            y: Theme.paddingSmall;
            horizontalAlignment: Text.AlignHCenter;
            wrapMode: Text.WrapAnywhere;

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    infoBanner.opacity = 0.0;
                    infoBanner.visible = false;
                }
            }
        }

        function showText(text) {
            infoLabel.text = text;
            opacity = 0.9;
            infoBanner.visible = true;
            //console.log("infoBanner: " + text);
            closeTimer.restart();
        }

        function showError(errorMessage) {
            infoLabel.text = errorMessage;
            opacity = 0.9;
            infoBanner.visible = true;
        }

        function showHttpError(errorCode, errorMessage) {
            console.log("API error: code=" + JSON.stringify(errorCode) + "; message=" + errorMessage);
            if (errorMessage.indexOf('{"data":{"error":') > -1) {
                try {
                    var jsonObject = JSON.parse(errorMessage);
                    showError(jsonObject.data.error);
                } catch (err) {
                    showError(errorMessage);
                }
            } else {
                showError(errorMessage);
            }

            /*
            switch (errorCode) {
                case 0:
                    showError(qsTr("Server or connection error."));
                    break;
                case 400:
                    showError(qsTr("Required parameter is missing or a parameter has a value that is out of bounds or otherwise incorrect."));
                    // This status code is also returned when image uploads fail due to images that are corrupt
                    // or do not meet the format requirements.
                    break;
                case 401:
                    showError(qsTr("The request requires user authentication."));
                    // Either you didn't send send OAuth credentials, or the ones you sent were invalid.
                    break;
                case 403:
                    showError(qsTr("Forbidden. You don't have access to this action."));
                    // If you're getting this error, check that you haven't run out of API credits
                    // or make sure you're sending the OAuth headers correctly and have valid tokens/secrets.
                    break;
                case 404:
                    showError(qsTr("Resource does not exist. You have requested a resource that does not exist."));
                    // For example, requesting an image that doesn't exist.
                    break;
                case 429:
                    showError(qsTr("Rate limiting. You have hit the rate limiting on the app or on the IP address. Please try again later."));
                    break;
                case 500:
                    showError(qsTr("Unexpected internal error. Something is broken with the Imgur service."));
                    break;
                default:
                    showError("Error: " + errorMessage + " (" + errorCode + ")");
            }
            */
        }

        Behavior on opacity { FadeAnimation {} }

        Timer {
            id: closeTimer;
            interval: 3000;
            onTriggered: {
                infoBanner.opacity = 0.0;
                infoBanner.visible = true;
            }
        }
    }

    Item {
        id: loadingRect;
        anchors.fill: parent;
        visible: false;
        z: 2;

        Rectangle {
            anchors.fill: parent;
            color: "black";
            opacity: 0.5;
        }

        BusyIndicator {
            anchors.centerIn: parent;
            visible: loadingRect.visible;
            running: visible;
            size: BusyIndicatorSize.Large;
            Behavior on opacity { FadeAnimation {} }
        }
    }

    Component.onCompleted: {
        settings.loadSettings();
    }
}


