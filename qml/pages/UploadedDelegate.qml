import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components/utils.js" as Utils

Item {
    id: uploadedDelegate;
    property Item contextMenu;
    property bool menuOpen: contextMenu != null && contextMenu.parent === uploadedDelegate;

    property string item_imgur_id;
    property string item_link;
    property string item_deletehash;

    height: menuOpen ? contextMenu.height + uploadedColumn.height : uploadedColumn.height;

    Column {
        id: uploadedColumn;

        width: listView.width;
        spacing: constant.paddingSmall;

        Label {
            id: titleLbl;
            width: parent.width;
            font.pixelSize: constant.fontSizeSmall;
            textFormat: Text.PlainText;
            wrapMode: Text.Wrap;
            text: title
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
                item_link = link;
                item_imgur_id = imgur_id;
                item_deletehash = deletehash;

                contextMenu = uploadedContextMenu.createObject(listView);
                contextMenu.show(uploadedDelegate);
            }
            text: link;
        }

        Row {
            width: parent.width;

            Label {
                id: datetimeLbl
                font.pixelSize: constant.fontSizeXXSmall;
                color: constant.colorHighlight;
                textFormat: Text.PlainText;
                text: Utils.formatEpochDatetime(datetime);
            }
        }
    }

    Component {
        id: uploadedContextMenu;

        UploadedContextMenu {
            imgur_id: item_imgur_id;
            link: item_link;
            deletehash: item_deletehash;
        }
    }
}
