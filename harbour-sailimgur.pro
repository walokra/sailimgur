TARGET = harbour-sailimgur

# Application version
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_RELEASE=\\\"$$RELEASE\\\"

# Qt Library
QT += svg

CONFIG += sailfishapp

SOURCES += main.cpp

OTHER_FILES = \
    rpm/harbour-sailimgur.spec \
    rpm/harbour-sailimgur.yaml \
    harbour-sailimgur.desktop \
    qml/main.qml \
    qml/cover/CoverPage.qml \
    qml/pages/Settings.qml \
    qml/pages/Constant.qml \
    qml/components/imgur.js \
    qml/pages/SettingsPage.qml \
    qml/pages/GalleryPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/CommentDelegate.qml \
    qml/pages/GalleryDelegate.qml \
    qml/pages/ImageButtons.qml \
    qml/pages/ImageContextMenu.qml \
    qml/pages/GalleryNavigation.qml \
    qml/pages/SignInPage.qml \
    qml/components/storage.js \
    qml/components/utils.js

INCLUDEPATH += $$PWD
