TEMPLATE=app
TARGET = harbour-sailimgur

# Application version
VERSION = 0.1.0
DEFINES += APP_VERSION=\"\\\"$$VERSION\\\"\"

# Qt Library
QT += svg

CONFIG += sailfishapp

SOURCES += main.cpp

OTHER_FILES = \
    ../rpm/harbour-sailimgur.yaml \
    ../rpm/harbour-sailimgur.spec \
    harbour-sailimgur.desktop \
    qml/main.qml \
    qml/cover/CoverPage.qml \
    qml/pages/Settings.qml \
    qml/components/imgur.js \
    qml/pages/SettingsPage.qml \
    qml/pages/GalleryPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/MainPage.qml

INCLUDEPATH += $$PWD
