/*
 * This file is part of harbour-sailimgur.
 * SPDX-FileCopyrightText: 2020-2025 Mirian Margiani
 * SPDX-FileCopyrightText: 2014 Marko Wallin
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

Row {
    readonly property int iconSize: Theme.itemSizeSmall;

    height: iconSize + 2 * Theme.paddingMedium;

    anchors {
        horizontalCenter: parent.horizontalCenter;
        bottomMargin: Theme.paddingMedium;
        topMargin: Theme.paddingMedium;
    }

    spacing: Theme.paddingLarge;

    IconButton {
        id: dlIcon

        visible: sailimgurMgr.canDownload
        enabled: visible && !savingInProgress

        icon {
            width: parent.iconSize
            height: parent.iconSize
            source: savingInProgress ? constant.iconSaving : constant.iconSave
        }

        onClicked: {
            savingInProgress = true;
            sailimgurMgr.saveImage(downloadUrl)
        }
    }

    IconButton {
        icon.width: parent.iconSize;
        icon.height: parent.iconSize;
        icon.source: constant.iconBrowser;
        onClicked: {
            //Qt.openUrlExternally(link);
            //infoBanner.showText(qsTr("Launching browser."));
            var props = {
                "url": link_original
            }
            pageStack.push(Qt.resolvedUrl("WebPage.qml"), props);
        }
    }

    IconButton {
        icon.width: parent.iconSize;
        icon.height: parent.iconSize;
        icon.source: constant.iconClipboard;
        onClicked: {
            Clipboard.text = link_original;
            infoBanner.showText(qsTr("Image link " + Clipboard.text + " copied to clipboard."));
        }
    }

    IconButton {
        icon.width: parent.iconSize;
        icon.height: parent.iconSize;
        icon.source: constant.iconInfo;
        onClicked: {
            //console.debug(JSON.stringify(galleryContentModel));
            var props = {
                "image_id": id,
                "image_width": vWidth,
                "image_height": vHeight,
                "type": type,
                "size": size,
                "views": views,
                "bandwith": bandwidth,
                "section": section,
                "animated": animated,
                "nsfw": nsfw,
                "ups": ups,
                "downs": downs
            }

            pageStack.push(Qt.resolvedUrl("ImageInfoPage.qml"), props)
        }
    }

    Connections {
        target: sailimgurMgr
        onSaveImageSucceeded: if (url == downloadUrl) savingInProgress = false
        onSaveImageFailed: if (url == downloadUrl) savingInProgress = false
        onErrorImageExists: if (url == downloadUrl) savingInProgress = false
        onErrorSavingDisabled: if (url == downloadUrl) savingInProgress = false
    }
}
