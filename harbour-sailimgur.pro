TARGET = harbour-sailimgur

# Application version
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_RELEASE=\\\"$$RELEASE\\\"

# Qt Library
QT += svg network multimedia

CONFIG += sailfishapp

HEADERS += \
    src/imageuploader.h \
    src/sailimgur.h

SOURCES += main.cpp \
    src/imageuploader.cpp \
    src/sailimgur.cpp

OTHER_FILES = \
    rpm/harbour-sailimgur.changes \
    rpm/harbour-sailimgur.spec \
    rpm/harbour-sailimgur.yaml \
    harbour-sailimgur.desktop \
    qml/main.qml \
    qml/cover/CoverPage.qml \
    qml/pages/Settings.qml \
    qml/pages/Constant.qml \
    qml/components/imgur.js \
    qml/pages/AboutPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/CommentDelegate.qml \
    qml/pages/GalleryDelegate.qml \
    qml/pages/ImageButtons.qml \
    qml/pages/ImageContextMenu.qml \
    qml/pages/SignInPage.qml \
    qml/components/storage.js \
    qml/components/utils.js \
    qml/pages/GalleryNavigation.qml \
    qml/pages/GalleryContentPage.qml \
    qml/pages/GalleryContentDelegate.qml \
    qml/pages/GalleryMode.qml \
    qml/pages/CommentsModel.qml \
    qml/pages/GalleryModel.qml \
    qml/pages/GalleryContentModel.qml \
    qml/pages/UploadPage.qml \
    qml/pages/WebPage.qml \
    qml/pages/AlbumInfoColumn.qml \
    qml/components/imgur_oauth.js \
    qml/pages/UploadedPage.qml \
    qml/pages/UploadedModel.qml \
    qml/pages/UploadedContextMenu.qml \
    qml/pages/UploadedDelegate.qml \
    qml/pages/ChangelogDialog.qml \
    qml/pages/Toolbar.qml \
    qml/pages/AccountPage.qml \
    qml/pages/SettingsDialog.qml \
    qml/pages/ActionBar.qml \
    qml/pages/SearchPanel.qml \
    qml/pages/ImageInfoPage.qml

INCLUDEPATH += $$PWD
