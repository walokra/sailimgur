#include "sailimgur.h"

#include <QStandardPaths>
#include <QDebug>

Sailimgur::Sailimgur(QObject *parent):
    QObject(parent),
    mReply(0),
    mImage(0) {
    mPictureLocation = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
}

Sailimgur::~Sailimgur() {
    if (mImage) {
        qDebug() << "Closing mImage";
        mImage->close();

        // if client was shut down during full image download
        if (mImage->size() == 0) {
            qDebug() << "Remove empty file";
            mImage->remove();
        }
        delete mImage;
        mImage = 0;
    }
}

void Sailimgur::saveImage(const QString &path) {
    QString name = path.split("/").last().split("@").first();
    qDebug() << "Requested to save" << path << "to gallery" << mPictureLocation << "with name" << name;

    if (QFile::exists(mPictureLocation + "/" + name)) {
        qDebug() << "Image already saved to" << mPictureLocation << "as" << name;
        emit errorImageExists(name);
        return;
    } else {
        mImage = new QFile;
        mImage->setFileName(mPictureLocation + "/" + name);

        QUrl imageUrl(path);
        QNetworkRequest request;
        request.setUrl(QUrl(imageUrl));
        mReply = mManager.get(request);
        connect(mReply, &QNetworkReply::finished,
                this, &Sailimgur::onSaveImageFinished);

        mImage->open(QIODevice::WriteOnly);
    }
}

void Sailimgur::onSaveImageFinished() {
    disconnect(mReply, &QNetworkReply::finished,
            this, &Sailimgur::onSaveImageFinished);
    if (!mReply->error()) {
        qDebug() << "Saving file";
        mImage->write(mReply->readAll());
        mImage->close();
        QString fname = mImage->fileName().split("/").last().split("@").first();
        emit saveImageSucceeded(fname);
        delete mImage;
        mImage = 0;
    }
    mReply->deleteLater();
    mReply = 0;
}
