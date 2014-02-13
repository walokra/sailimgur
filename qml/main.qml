import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

ApplicationWindow
{
    id: main;

    property int page : 0;
    property int currentIndex : 0;
    property bool loggedIn : false;

    property string creditsUserRemaining : "";
    property string creditsClientRemaining : "";

    initialPage: Component { MainPage { id: mainPage; } }

    cover: CoverPage { id: coverPage; }

    ListModel { id: galleryModel; }

    GalleryContentPage{ id: galleryContentPage; }

    AboutPage { id: aboutPage; }

    SettingsPage { id: settingsPage; }

    Settings { id: settings; }

    Constant { id: constant; }

    SignInPage { id: signInPage; }

    Rectangle {
        id: infoBanner;
        y: Theme.paddingSmall;
        z: 1;
        width: parent.width;

        height: infoLabel.height + 2 * Theme.paddingMedium;
        color: Theme.highlightBackgroundColor;
        opacity: 0;

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
                }
            }
        }

        function showText(text) {
            infoLabel.text = text;
            opacity = 0.9;
            //console.log("infoBanner: " + text);
            closeTimer.restart();
        }

        function showError(text) {
            infoLabel.text = text;
            opacity = 0.9;
            console.log("infoBanner: " + text);
        }

        function showHttpError(errorCode, errorMessage) {
            showError(errorMessage);
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
            onTriggered: infoBanner.opacity = 0.0;
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


