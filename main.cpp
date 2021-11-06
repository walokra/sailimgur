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

#define CLIENT_ID "44f3bd95ad7db12"
#define CLIENT_SECRET ""

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

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    clearWebCache();

    QScopedPointer<QQuickView> view(SailfishApp::createView());

    app->setApplicationName("harbour-sailimgur");
    app->setOrganizationName("harbour-sailimgur");
    app->setApplicationVersion(APP_VERSION);

    view->rootContext()->setContextProperty("APP_VERSION", APP_VERSION);
    view->rootContext()->setContextProperty("APP_RELEASE", APP_RELEASE);

    view->rootContext()->setContextProperty("CLIENT_ID", CLIENT_ID);
    view->rootContext()->setContextProperty("CLIENT_SECRET", CLIENT_SECRET);

    Sailimgur mgr;
    view->rootContext()->setContextProperty("sailimgurMgr", &mgr);

    qmlRegisterType<ImageUploader>("harbour.sailimgur.Uploader", 1, 0, "ImageUploader");

    view->setSource(SailfishApp::pathTo("qml/main.qml"));
    view->show();

    return app->exec();
}
