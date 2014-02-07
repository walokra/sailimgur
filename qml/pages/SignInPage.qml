import QtQuick 2.1
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur

Page {
    id: signInPage;

    SilicaFlickable {
        id: signInFlickable;

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
            height: childrenRect.height;
            spacing: Theme.paddingMedium;

            Label {
                id: helpLabel;
                anchors { left: parent.left; right: parent.right }
                font.pixelSize: Theme.fontSizeMedium;
                wrapMode: Text.Wrap;
                text: qsTr("To use Sailimgur, you must sign in to your imgur account first. \
Click the button below will launch an external web browser for you to sign in.");
            }

            Item {
                anchors.horizontalCenter: parent.horizontalCenter;
                width: signInButton.width;
                height: signInButton.height + 2 * Theme.paddingLarge;

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
                font.pixelSize: Theme.fontSizeMedium;
                wrapMode: Text.Wrap;
                text: qsTr("After sign in, a PIN code will display. Enter the PIN code in the text field below and click done.");
            }

            Item {
                id: pinCodeTextFieldWrapper;
                anchors { left: parent.left; right: parent.right; }
                height: pinCodeTextField.height + 2 * Theme.paddingMedium;

                TextField {
                    id: pinCodeTextField;
                    anchors.centerIn: parent;
                    width: parent.width;
                    inputMethodHints: Qt.ImhDigitsOnly;
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

        VerticalScrollDecorator {}
    }

    QtObject {
        id: internal;

        function doneButtonClicked() {
            settings.resetTokens();

            Imgur.exchangePinForAccessToken(pinCodeTextField.text,
                function (access_token, refresh_token) {
                    settings.accessToken = access_token;
                    settings.refreshToken = refresh_token;
                    infoBanner.showText(qsTr("Signed in successfully"));
                    settings.saveTokens();
                    settings.settingsLoaded();
                    // back to main page
                    pageStack.pop(null);
                },
                function(status, statusText) {
                    if (status === 401) {
                        pinCodeTextField.text = "";
                        infoBanner.showText(qsTr("Error: Unable to authorize with imgur. Please sign in again and enter the correct PIN code."))
                    }
                    else infoBanner.showHttpError(status, statusText);
                    header.busy = false;
                });
                header.busy = true;
        }
    }
}
