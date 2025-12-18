/*
 * This file is part of harbour-sailimgur.
 * SPDX-FileCopyrightText: 2025 Mirian Margiani
 * SPDX-FileCopyrightText: 2014 Marko Wallin
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "cover"

ApplicationWindow {
    id: main;

    property Page currentPage: pageStack.currentPage

    property int pageNo : 0;
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

    QtObject {
        id: infoBanner

        function showText(text) {
            Notices.show(text, 3000, Notice.Top)
        }

        function showError(errorMessage) {
            Notices.show(errorMessage, 3000, Notice.Center)
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

    Connections {
        target: sailimgurMgr

        onSaveImageSucceeded: {
            Notices.show(qsTr("Image saved as “%1”").arg(name), 5000, Notice.Bottom)
        }
        onSaveImageFailed: {
            Notices.show(qsTr("Failed to download “%1”").arg(name), 5000, Notice.Bottom)
        }
        onErrorImageExists: {
            Notices.show(qsTr("Image already saved as “%1”").arg(name), 5000, Notice.Bottom)
        }
        onErrorSavingDisabled: {
            // TODO recommend to check the logs
            Notices.show(qsTr("Saving images is not possible"), 5000, Notice.Bottom)
        }
    }

    Component.onCompleted: {
        settings.loadSettings();
    }
}
