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
                height: pinCodeTextFieldRow.height + 2 * Theme.paddingMedium;

                Row {
                    id: pinCodeTextFieldRow;
                    anchors.centerIn: parent;
                    width: childrenRect.width; height: pinCodeTextField.height;
                    spacing: Theme.paddingLarge;

                    Label {
                        font.pixelSize: Theme.fontSizeMedium;
                        text: "PIN:";
                    }

                    TextField {
                        id: pinCodeTextField;
                        width: pinCodeTextFieldWrapper.width * 0.7;
                        inputMethodHints: Qt.ImhDigitsOnly;

                        EnterKey.enabled: text.length > 0;
                        EnterKey.iconSource: "image://theme/icon-m-enter-accept";
                        EnterKey.onClicked: {
                            internal.doneButtonClicked();
                        }
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

        ScrollDecorator {}
    }

    QtObject {
        id: internal;

        function doneButtonClicked() {
            Imgur.exchangePinForAccessToken(pinCodeTextField.text);
            infoBanner.showText(qsTr("Signed in successfully"));
            settings.settingsLoaded();
        }
    }
}
