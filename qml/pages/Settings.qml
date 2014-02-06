import QtQuick 2.0
import "../components/storage.js" as Storage

QtObject {
    id: settings;

    signal settingsLoaded;

    property string access_token : "";
    property string refresh_token : "";

    // Settings page
    property int albumImagesLimit: 10;
    property bool showComments: false;

    // default options for gallery
    property string mode : "main";
    property string section : "hot"; // hot | top | user
    property string sort : "viral"; // viral | time
    property string window : "day"; // day | week | month | year | all
    property bool showViral : true; // true | false
    property bool autoplayAnim: true; // play anim gifs automatically?

    function loadSettings() {
        //console.log("Load settings...");
        Storage.db = Storage.connect();

        var results = Storage.getAllSettings();
        for (var s in results) {
            if (settings.hasOwnProperty(s)) {
                settings[s] = results[s]
            }
        }
        settingsLoaded();
    }

}
