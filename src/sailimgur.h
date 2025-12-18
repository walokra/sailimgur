/*
 * This file is part of harbour-sailimgur.
 * SPDX-FileCopyrightText: 2025 Mirian Margiani
 * SPDX-FileCopyrightText: 2014 Marko Wallin
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef SAILIMGUR_H
#define SAILIMGUR_H

#include <QObject>
#include <QHash>
#include <QFutureWatcher>

class Sailimgur: public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool canDownload READ canDownload NOTIFY canDownloadChanged)

public:
    Sailimgur(QObject *parent = 0);
    ~Sailimgur();

    Q_INVOKABLE bool isDownloading(QString url);
    Q_INVOKABLE void saveImage(const QString &url);

    bool canDownload() { return mCanDownload; }

private:
    QString mPictureLocation;
    bool mCanDownload {true};
    QHash<QString, QSharedPointer<QFutureWatcher<bool>>> mQueue;

signals:
    void saveImageSucceeded(const QString &name, const QString &url);
    void saveImageFailed(const QString &name, const QString &url);
    void errorImageExists(const QString &name, const QString &url);
    void errorSavingDisabled();

    void canDownloadChanged();
};

#endif // SAILIMGUR_H
