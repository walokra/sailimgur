import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/utils.js" as Utils

Item {
    id: uploadedDelegate;
    property Item contextMenu;
    property bool menuOpen: contextMenu != null && contextMenu.parent === uploadedDelegate;

    property bool show_item: false;
    property bool show_extra: false;
    property bool item_is_album: false;
    property string item_title: "";
    property string item_imgur_id: "";
    property string item_link: "";
    property string item_deletehash: "";
    property string item_datetime: "";
    property var parent_item;

    visible: show_item;

    height: menuOpen ? contextMenu.height + uploadedColumn.height : uploadedColumn.height;

    Column {
        id: uploadedColumn;

        width: parent.width;
        spacing: constant.paddingSmall;

        Label {
            id: titleLbl;
            width: parent.width;
            font.pixelSize: constant.fontSizeSmall;
            textFormat: Text.PlainText;
            wrapMode: Text.Wrap;
            text: item_title
            visible: show_extra;
        }
        Label {
            id: linkLbl;
            width: parent.width;
            font.pixelSize: constant.fontSizeSmall;
            textFormat: Text.StyledText;
            linkColor: Theme.highlightColor;
            truncationMode: TruncationMode.Fade;
            wrapMode: Text.Wrap;
            onLinkActivated: {
                contextMenu = uploadedContextMenu.createObject(parent_item);
                contextMenu.show(uploadedDelegate);
            }
            text: Utils.replaceURLWithHTMLLinks(item_link);
        }

        Row {
            width: parent.width;
            visible: show_extra;

            Label {
                id: datetimeLbl
                font.pixelSize: constant.fontSizeXXSmall;
                color: constant.colorHighlight;
                textFormat: Text.PlainText;
                text: Utils.formatEpochDatetime(item_datetime);
            }
        }
    }

    Component {
        id: uploadedContextMenu;

        UploadedContextMenu {
            is_album: item_is_album;
            imgur_id: item_imgur_id;
            link: item_link;
            deletehash: item_deletehash;
        }
    }
}
