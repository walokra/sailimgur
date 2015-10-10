import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/imgur.js" as Imgur
import "../components/utils.js" as Utils

Page {
    id: root;

    signal load();

    property int account_id : 0
    property string  url : "anonymous";
    property string bio : "";
    property string created : "";
    property int reputation : 0;
    //property var pro_expiration : false;

    onLoad: {
        internal.getAccount();
    }

    onStatusChanged: {
        //console.debug("onStatusChanged");
        //console.debug("pageStack.depth=" + pageStack.depth);
        if (status === PageStatus.Inactive) {
            //console.debug("PageStatus.Inactive, pageStack.depth=" + pageStack.depth);
            // If going to back to main page, reset the mode
            if (pageStack.depth == 1) {
                var mode = settings.mode;
                settings.mode = settings.readSetting("mode");
                if (settings.mode !== mode) {
                    internal.setCommonValues();
                }
            }
        }
    }

    SilicaFlickable {
        pressDelay: 0;

        anchors.fill: parent;
        contentHeight: contentArea.height;

        PageHeader { id: header; title: qsTr("Profile"); }

        Column {
            id: contentArea;
            width: parent.width;
            height: childrenRect.height;

            anchors { top: header.bottom; left: parent.left; right: parent.right; margins: Theme.paddingLarge; }
            spacing: constant.paddingLarge;

            Label {
                anchors { left: parent.left; right: parent.right; }
                text: url;
                color: constant.colorHighlight;
                width: parent.width;
            }
            Label {
                anchors { left: parent.left; right: parent.right; }
                text: bio;
                visible: (bio != "") ? true : false;
                color: constant.colorHighlight;
                font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                width: parent.width;
            }

            Row {
                anchors { left: parent.left; right: parent.right; }
                spacing: Theme.paddingMedium;

                Label {
                    text: reputation + qsTr(" reputation");
                    color: constant.colorHighlight;
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeSmall : constant.fontSizeXSmall
                }

                Label {
                    text: "|";
                    color: constant.colorHighlight;
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeSmall : constant.fontSizeXSmall
                }

                Label {
                    text: qsTr("Member since ") + created;
                    color: constant.colorHighlight;
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeSmall : constant.fontSizeXSmall
                }

                /*
                Label {
                    text: qsTr("Pro: ") + pro_expiration;
                    color: constant.colorHighlight;
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                    ? constant.fontSizeSmall : constant.fontSizeXSmall
                }
                */
            }

            BackgroundItem {
                id: uploadsItem;
                anchors.left: parent.left; anchors.right: parent.right;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("Uploaded images");
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeLarge : constant.fontSizeMedium
                    color: uploadsItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    pageStack.push(uploadedPage);
                    uploadedPage.load();
                }
            }

            BackgroundItem {
                id: favoritesItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("Favorites");
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeLarge : constant.fontSizeMedium
                    color: favoritesItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    settings.mode = constant.mode_favorites;

                    internal.setCommonValues();
                    pageStack.push(mainPage);
                }
            }

            BackgroundItem {
                id: albumsItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("Albums");
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeLarge : constant.fontSizeMedium
                    color: albumsItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    settings.mode = constant.mode_albums;

                    internal.setCommonValues();
                    pageStack.push(mainPage);
                }
            }

            BackgroundItem {
                id: imagesItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("Images");
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeLarge : constant.fontSizeMedium
                    color: imagesItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    settings.mode = constant.mode_images;

                    internal.setCommonValues();
                    pageStack.push(mainPage);
                }
            }

            /*
            BackgroundItem {
                id: messagesItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("messages");
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                            ? constant.fontSizeLarge : constant.fontSizeMedium
                    color: messagesItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {

                }
            }

            BackgroundItem {
                id: accountSettingsItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("account settings");
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                            ? constant.fontSizeLarge : constant.fontSizeMedium
                    color: accountSettingsItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {

                }
            }
            */

            BackgroundItem {
                id: logoutItem;
                anchors.left: parent.left; anchors.right: parent.right;
                visible: loggedIn;

                Label {
                    anchors { left: parent.left; right: parent.right; }
                    anchors.verticalCenter: parent.verticalCenter;
                    text: qsTr("Logout");
                    font.pixelSize: Screen.sizeCategory >= Screen.Large
                                        ? constant.fontSizeLarge : constant.fontSizeMedium
                    color: imagesItem.highlighted ? constant.colorHighlight : constant.colorPrimary;
                }

                onClicked: {
                    loggedIn = false;
                    settings.resetTokens();
                    settings.settingsLoaded();
                    internal.setCommonValues();

                    root.backNavigation = true;
                    pageStack.pop(PageStackAction.Animated);
                }
            }
        }

        VerticalScrollDecorator { }
    }

    QtObject {
        id: internal;

        function getAccount() {
            if (loggedIn) {
                Imgur.getAccount(settings.user,
                    function(output, status) {
                        parseAccount(output);
                    },
                    function(status, statusText) {
                        infoBanner.showHttpError(status, statusText);
                    }
                );
            }
        }

        function setCommonValues() {
            currentIndex = 0;
            page = 0;
            galleryModel.query = "";
            galleryModel.clear();
            galleryModel.processGalleryMode();
        }

        function parseAccount(output) {
            var monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];

            var date = new Date(output.created * 1000);
            date = monthNames[date.getMonth()]  + " " + date.getFullYear();

            //var pro_expr = (pro_expiration === false) ? pro_expiration : Utils.formatEpochDatetime(output.pro_expiration);
            account_id = output.id;
            url = output.url;
            bio = output.bio;
            created = date;
            reputation = output.reputation;
            //pro_expiration = pro_expr;
        }
    }
}
