import QtQuick 2.0

QtObject {
    id: settings;

    property string appName : "Sailimgur";

    property string client_id : "";
    property string client_secret : "";

    property string user_agent : appName + " " + APP_VERSION + "-" + APP_RELEASE + "(Jolla; Qt; SailfishOS)";

    // default options for gallery
    property string mode : "main";
    property string section : "hot"; // hot | top | user
    property string sort : "viral"; // viral | time
    property string window : "day"; // day | week | month | year | all
    property bool showViral : true; // true | false

    property bool autoplayAnim: true; // play anim gifs automatically?
    property bool showComments: false;

    property int commentPointsLimit: 1;
    property int albumImagesLimit: 10;

}
