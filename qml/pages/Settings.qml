import QtQuick 2.0
import "../components/storage.js" as Storage

QtObject {
    id: settings;

    signal settingsLoaded;

    property string accessToken : "";
    property string refreshToken : "";

    // Settings page
    property int albumImagesLimit: 3;
    property bool showComments: false;

    // user
    property string user: "anonymous";

    // default options for gallery
    property string mode : "main";
    property string section : "hot"; // hot | top | user
    property string sort : "viral"; // viral | time
    property string window : "day"; // day | week | month | year | all
    property bool showViral : false; // true | false
    property bool autoplayAnim: true; // play anim gifs automatically?

    function loadSettings() {
        Storage.db = Storage.connect();
        //console.log("Load settings...");
        var results = Storage.readAllSettings(Storage.db);
        for (var s in results) {
            if (settings.hasOwnProperty(s)) {
                settings[s] = results[s];
            }
        }
        readTokens(Storage.db);
        settingsLoaded();
    }

    function resetTokens() {
        Storage.db = Storage.connect();
        accessToken = "";
        refreshToken = "";
        Storage.writeSetting(Storage.db, "accessToken", accessToken);
        Storage.writeSetting(Storage.db, "refreshToken", refreshToken);
    }

    function saveTokens() {
        Storage.db = Storage.connect();
        Storage.writeToken(Storage.db, "accessToken", accessToken, constant.clientSecret);
        Storage.writeToken(Storage.db, "refreshToken", refreshToken, constant.clientSecret);
    }

    function readTokens() {
        Storage.db = Storage.connect();
        accessToken = Storage.readToken(Storage.db, "accessToken", constant.clientSecret);
        refreshToken = Storage.readToken(Storage.db, "refreshToken", constant.clientSecret);
    }

}
