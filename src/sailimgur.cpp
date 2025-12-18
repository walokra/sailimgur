/*
 * This file is part of harbour-sailimgur.
 * SPDX-FileCopyrightText: 2025 Mirian Margiani
 * SPDX-FileCopyrightText: 2014 Marko Wallin
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "sailimgur.h"

#include <QtConcurrent/QtConcurrentRun>
#include <QStandardPaths>
#include <QDir>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QFileInfo>
#include <QEventLoop>
#include <QDebug>

Sailimgur::Sailimgur(QObject *parent) :
    QObject(parent)
{
    mPictureLocation = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);

    if (mPictureLocation.isEmpty()) {
        qDebug() << "Saving disabled: no suitable data location found";
    } else {
        mPictureLocation += "/Sailimgur";

        auto picsInfo = QFileInfo(mPictureLocation);

        if (picsInfo.exists() && !picsInfo.isDir()) {
            qDebug() << "Saving disabled: target is not a directory at" << mPictureLocation;
            mPictureLocation = "";
        } else if (!QDir().mkpath(mPictureLocation)) {
            qDebug() << "Saving disabled: failed to create target directory at" << mPictureLocation;
            mPictureLocation = "";
        }
    }

    mCanDownload = !mPictureLocation.isEmpty();
    emit canDownloadChanged();
}

Sailimgur::~Sailimgur() {}

bool Sailimgur::isDownloading(QString name)
{
    return mQueue.contains(name);
}

void Sailimgur::saveImage(const QString &url) {
    if (mPictureLocation.isEmpty() || !QFileInfo(mPictureLocation).isDir()) {
        emit errorSavingDisabled();
        return;
    }

    if (isDownloading(url)) {
        return;
    }

    QString name = url.split("/").last().split("@").first();
    auto imageInfo = QFileInfo(mPictureLocation + "/" + name);
    qDebug() << "Requested to save" << url << "to" << imageInfo.absoluteFilePath();

    auto watcher = QSharedPointer<QFutureWatcher<bool>>(new QFutureWatcher<bool>());
    connect(watcher.data(), &QFutureWatcher<bool>::finished, this, [this, url](){
        qDebug() << "Removing" << url << "from download queue";
        mQueue.remove(url);
    });

    auto future = QtConcurrent::run([this, imageInfo, name, url]() -> bool {
        if (imageInfo.exists()
                && imageInfo.isReadable()
                && imageInfo.isFile()
                && imageInfo.size() == 0) {
            qDebug() << "Removing empty file" << imageInfo.absoluteFilePath();
        } else if (imageInfo.exists()) {
            qDebug() << "Image already saved to" << imageInfo.absoluteFilePath();
            emit errorImageExists(name, url);
            return false;
        }

        QNetworkAccessManager manager;
        auto request = QNetworkRequest(QUrl(url));
        auto* reply = manager.get(request);

        QEventLoop loop;
        connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();

        if (reply->error()) {
            qDebug() << "Failed to download" << imageInfo.absoluteFilePath();
            emit saveImageFailed(name, url);
            return false;
        }

        QFile localFile(imageInfo.absoluteFilePath());

        if (!localFile.open(QIODevice::WriteOnly)) {
            qDebug() << "Failed to open" << imageInfo.absoluteFilePath() << "for saving";
            emit saveImageFailed(name, url);
            return false;
        }

        qDebug() << "Saving downloaded file" << imageInfo.absoluteFilePath();
        const QByteArray sdata = reply->readAll();
        localFile.write(sdata);
        localFile.close();

        emit saveImageSucceeded(name, url);
        return true;
    });

    qDebug() << "Adding" << url << "to download queue";
    watcher->setFuture(future);
    mQueue.insert(url, watcher);
}
