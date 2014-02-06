import QtQuick 2.0
import Sailfish.Silica 1.0

QtObject {
    id: constant;

    property string appName : "Sailimgur";

    // Imgur API Key/Secret
    property string clientId : "956cdde55ca20c8";
    property string clientSecret : "";

    property string userAgent : appName + " " + APP_VERSION + "-" + APP_RELEASE + "(Jolla; Qt; SailfishOS)";

    property int commentPointsLimit: 1;

}
