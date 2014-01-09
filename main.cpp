#include <sailfishapp.h>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>

int main(int argc, char *argv[])
{

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    app->setApplicationName("Sailimgur");
    app->setOrganizationName("Sailimgur");
    app->setApplicationVersion(APP_VERSION);

    view->setSource(SailfishApp::pathTo("qml/main.qml"));
    view->rootContext()->setContextProperty("APP_VERSION", APP_VERSION);

    view->show();

    return app->exec();
}
