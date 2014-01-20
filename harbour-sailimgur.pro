TARGET = harbour-sailimgur

# Application version
VERSION = 0.1.0
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

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
    qml/components/imgur.js \
    qml/pages/SettingsPage.qml \
    qml/pages/GalleryPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/CommentDelegate.qml \
    qml/pages/GalleryDelegate.qml

INCLUDEPATH += $$PWD
