import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: signInPage;
    allowedOrientations: Orientation.All;

    property bool refreshDone : false;

    SilicaFlickable {
        id: flickable;

        anchors.fill: parent;
        contentHeight: contentArea.height;

        PageHeader {
            id: header
            title: qsTr("Sign In to imgur");
            property bool busy: false;
        }

        Column {
            id: contentArea;
            anchors { top: header.bottom; left: parent.left; right: parent.right; }
            anchors.leftMargin: constant.paddingSmall;
            anchors.rightMargin: constant.paddingSmall;
            height: childrenRect.height;
            spacing: constant.paddingMedium;

            Label {
                id: helpLabel;
                anchors { left: parent.left; right: parent.right }
                font.pixelSize: constant.fontSizeMedium;
                wrapMode: Text.Wrap;
                text: qsTr("To use Sailimgur, you must sign in to your imgur account first. \
Click the button below will launch an external web browser for you to sign in.");
            }

            Item {
                anchors.horizontalCenter: parent.horizontalCenter;
                width: signInButton.width;
                height: signInButton.height + 2 * constant.paddingLarge;

                Button {
                    id: signInButton;
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("Sign In");
                    onClicked: {
                        var signInUrl = Imgur.AUTHORIZE_URL+"?client_id="+constant.clientId+"&response_type=pin";
                        console.log("Launching web browser with url:", signInUrl);
                        Qt.openUrlExternally(signInUrl);
                        infoBanner.showText("Launching external web browser...");
                        header.busy = false;
                    }
                }
            }

            Label {
                id: afterLabel;
                anchors { left: parent.left; right: parent.right; }
                font.pixelSize: constant.fontSizeMedium;
                wrapMode: Text.Wrap;
                text: qsTr("After sign in, a PIN code will display. Enter the PIN code in the text field below and click done.");
            }

            Item {
                id: pinCodeTextFieldWrapper;
                anchors { left: parent.left; right: parent.right; }
                height: pinCodeTextField.height + 2 * constant.paddingMedium;

                TextField {
                    id: pinCodeTextField;
                    anchors.centerIn: parent;
                    width: parent.width;
                    //inputMethodHints: Qt.ImhDigitsOnly;
                    placeholderText: qsTr("PIN");
                    label: qsTr("PIN");

                    EnterKey.enabled: text.length > 0;
                    EnterKey.iconSource: "image://theme/icon-m-enter-accept";
                    EnterKey.onClicked: {
                        internal.doneButtonClicked();
                    }
                }
            }

            Button {
                id: doneButton;
                anchors.horizontalCenter: parent.horizontalCenter;
                enabled: pinCodeTextField.text != "";
                text: qsTr("Done");
                onClicked: {
                    internal.doneButtonClicked();
                }
            }
        }

        VerticalScrollDecorator { flickable: flickable; }
    }

    QtObject {
        id: internal;

        function doneButtonClicked() {
            settings.resetTokens();

            Imgur.exchangePinForAccessToken(pinCodeTextField.text,
                function (access_token, refresh_token) {
                    loggedIn = true;
                    settings.accessToken = access_token;
                    settings.refreshToken = refresh_token;
                    infoBanner.showText(qsTr("Signed in successfully"));
                    settings.saveTokens();
                    settings.settingsLoaded();
                    // back to main page
                    pageStack.pop(null);
                },
                function(status, statusText) {
                    loggedIn = false;
                    if (status === 401) {
                        pinCodeTextField.text = "";
                        infoBanner.showText(qsTr("Error: Unable to authorize with imgur. Please sign in again and enter the correct PIN code."))
                    }
                    else {
                        infoBanner.showHttpError(status, statusText);
                        header.busy = false;
                    }
                }
            );
            header.busy = true;
        }
    }

    function init() {
        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);
    }

    function tryRefreshingTokens(onSuccess) {
        console.log("Permission denied. Trying to refresh tokens.");
        loggedIn = false;
        refreshDone = true;

        Imgur.refreshAccessToken(settings.refreshToken,
            function(access_token, refresh_token) {
                console.log("Tokens refreshed.");
                loggedIn = true;
                refreshDone = false; // new tokens, we can retry later again
                settings.accessToken = access_token;
                settings.refreshToken = refresh_token;
                settings.saveTokens();
                onSuccess();
            }, function(status, statusText) {
                loggedIn = false;
                infoBanner.showHttpError(status, statusText + ". Can't refresh tokens. Please sign in again.");
                loadingRect.visible = false;
                settings.resetTokens();
            }
        );
    }
}
