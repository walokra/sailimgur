#ifndef SAILIMGUR_H
#define SAILIMGUR_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>

class Sailimgur: public QObject
{
    Q_OBJECT

public:
    Sailimgur(QObject *parent = 0);
    ~Sailimgur();

private:
    QNetworkAccessManager mManager;
    QNetworkReply* mReply;
    QFile* mImage;
    QString mPictureLocation;

signals:
    void saveImageSucceeded(const QString &name);
    void errorImageExists(const QString &name);

public slots:
    void saveImage(const QString &path);

public slots:
    void onSaveImageFinished();
};

#endif // SAILIMGUR_H
