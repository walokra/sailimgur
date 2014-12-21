import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: root
    objectName: "WebPage"

    property string url

    // work around Silica bug: don't let webview enable forward navigation
    onForwardNavigationChanged: {
        if (forwardNavigation) {
            forwardNavigation = false;
        }
    }

    allowedOrientations: Orientation.All

    Loader {
        id: loader

        anchors.fill: parent
        sourceComponent: parent.status === PageStatus.Active ? webComponent : undefined
    }

    Component {
        id: webComponent

        SilicaWebView {
            id: webview

            header: PageHeader {
                title: webview.title
            }

            PullDownMenu {
                MenuItem {
                    text: qsTr("Close web view")

                    onClicked: {
                        root.backNavigation = true;
                        pageStack.pop(PageStackAction.Animated);
                    }
                }

                MenuItem {
                    text: qsTr("Copy link to clipboard");
                    onClicked: {
                        Clipboard.text = url;
                        infoBanner.showText(qsTr("Link") + " " + Clipboard.text + " " + qsTr("copied to clipboard."));
                    }
                }

                MenuItem {
                    text: qsTr("Open in external browser")

                    onClicked: {
                        Qt.openUrlExternally(root.url);
                    }
                }
            }

            Component.onCompleted: {
                try {
                    experimental.userAgent =
                            "Mozilla/5.0 (Maemo; Linux; Jolla; Sailfish; Mobile) " +
                            "AppleWebKit/534.13 (KHTML, like Gecko) " +
                            "NokiaBrowser/8.5.0 Mobile Safari/534.13";
                } catch (err) {

                }
            }

            url: root.url
        }
    }

    BusyIndicator {
        running: loader.item ? loader.item.loading : false
        anchors.centerIn: parent
        size: BusyIndicatorSize.Large
    }

}
