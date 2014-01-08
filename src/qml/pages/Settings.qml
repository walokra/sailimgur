import QtQuick 2.0

QtObject {
    id: settings;

    property string baseurl : "https://api.imgur.com/3";

    // http://api.imgur.com/endpoints/gallery
    // https://api.imgur.com/3/gallery/{section}/{sort}/{page}?showViral=bool
    property string endpoint_gallery_main : baseurl + "/" + "gallery/hot/viral/0.json";
    property string endpoint_gallery_image : baseurl + "/" + "gallery/image"
    property string endpoint_gallery_album : baseurl + "/" + "gallery/album";
    property string endpoint_gallery : baseurl + "/" + "gallery";
    // https://api.imgur.com/3/gallery/random/random/{page}
    property string endpoint_gallery_random : baseurl + "/" + "gallery/random/random";
    // https://api.imgur.com/3/gallery/search/{sort}/{page}?q=string
    property string endpoint_gallery_search : baseurl + "/" + "gallery/search";

    property string client_id : "";
    property string client_secret : "";

    // default options for gallery
    property string mode : "main";
    property string section : "hot"; // hot | top | user
    property string sort : "viral"; // viral | time
    property string window : "top"; // day | week | month | year | all
    property bool showViral : true; // true | false

    property string galleryModeText : "The most viral images, sorted by popularity";
    property string galleryModeTextDefault : "The most viral images, sorted by popularity";
    property string galleryModeTextRandom: "Randomly selected images";

}
