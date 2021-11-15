#include <sailfishapp.h>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QtQml>
#include <QDebug>

#include "src/imageuploader.h"
#include "src/sailimgur.h"
#include "src/simplecrypt.h"

#define CLIENT_ID "44f3bd95ad7db12"
#define CLIENT_SECRET "AwLij1UYyeMhkq3xUEvNu3DH9/1YEMbtcZb3pQ5GwLB5yviiARnO5X3N+6VS"

/**
 * Clears the web cache, because Qt 5.2 WebView chokes on caches from older Qt versions.
 */
void clearWebCache() {
    const QStringList cachePaths = QStandardPaths::standardLocations(
                QStandardPaths::CacheLocation);

    if (cachePaths.size()) {
        // some very old versions of SailfishOS may not find this cache,
        // but that's OK since they don't have the web cache bug anyway
        const QString webCache = QDir(cachePaths.at(0)).filePath(".QtWebKit");
        QDir cacheDir(webCache);
        if (cacheDir.exists()) {
            if (cacheDir.removeRecursively()) {
                qDebug() << "Cleared web cache:" << webCache;
            } else {
                qDebug() << "Failed to clear web cache:" << webCache;
            }
        } else {
            qDebug() << "Web cache does not exist:" << webCache;
        }
    } else {
        qDebug() << "No web cache available.";
    }
}

int main(int argc, char *argv[])
{

    SimpleCrypt *crypto = new SimpleCrypt();
    crypto->setKey(0xd2fa13b37d936b07);
    //QString secret = crypto->encryptToString(QString(""));
    //qDebug() << "secret:" << secret;
    QString client_secret = crypto->decryptToString(QString(CLIENT_SECRET));

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    clearWebCache();

    QScopedPointer<QQuickView> view(SailfishApp::createView());

    app->setApplicationName("harbour-sailimgur");
    app->setOrganizationName("harbour-sailimgur");
    app->setApplicationVersion(APP_VERSION);

    view->rootContext()->setContextProperty("APP_VERSION", APP_VERSION);
    view->rootContext()->setContextProperty("APP_RELEASE", APP_RELEASE);

    view->rootContext()->setContextProperty("CLIENT_ID", CLIENT_ID);
    view->rootContext()->setContextProperty("CLIENT_SECRET", client_secret);

    Sailimgur mgr;
    view->rootContext()->setContextProperty("sailimgurMgr", &mgr);

    qmlRegisterType<ImageUploader>("harbour.sailimgur.Uploader", 1, 0, "ImageUploader");

    view->setSource(SailfishApp::pathTo("qml/main.qml"));
    view->show();

    return app->exec();
}
