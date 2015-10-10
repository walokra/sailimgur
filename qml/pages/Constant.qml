import QtQuick 2.0
import Sailfish.Silica 1.0

QtObject {
    id: constant;

    property string appName : "Sailimgur";

    // imgur API key/secret
    // The OAuth2 key/secret pair below are only for testing
    // Release version in Jolla Store / OpenRepos has a different key pair
    property string clientId : "";
    property string clientSecret : "";

    property string userAgent : appName + " " + APP_VERSION + "-" + APP_RELEASE + "(Jolla; Qt; SailfishOS)";

    property int commentPointsLimit : 1;

    // easier access to colors
    property color colorHighlight : Theme.highlightColor;
    property color colorPrimary : Theme.primaryColor;
    property color colorSecondary : Theme.secondaryColor;
    property color colorHilightSecondary : Theme.secondaryHighlightColor;
    property color backgroundColor: Theme.rgba(Theme.secondaryHighlightColor, 0.1);

    property color iconDefaultColor: Theme.rgba(Theme.secondaryColor, 0.4);

    // easier access to padding size
    property int paddingSmall : Theme.paddingSmall;
    property int paddingMedium : Theme.paddingMedium;
    property int paddingLarge : Theme.paddingLarge;
    property int paddingExtraLarge : 2 * Theme.paddingMedium;

    // easier access to item size
    property int itemSizeExtraSmall: Theme.itemSizeExtraSmall; // suits the smallest UI controls; used as the height of buttons and pulley menu entries
    property int itemSizeSmall: Theme.itemSizeSmall; // suits small UI controls; used as the height of list items with one line of text
    property int itemSizeMedium: Theme.itemSizeMedium; // suits average-sized UI controls; used as the height of list items with two lines of text
    property int itemSizeLarge: Theme.itemSizeLarge; // suits controls with several lines of text or more prominent text; this is the height of a page header in portrait orientation
    property int itemSizeExtraLarge: Theme.itemSizeExtraLarge; // suits larger items such as list delegates with an image thumbnail and associated image details
    property int itemSizeHuge: Theme.itemSizeHuge; // suits larger items such as images in a fullscreen grid of thumbnail images

    property int iconSizeExtraSmall: Theme.iconSizeExtraSmall; // suits the smallest icons, such as those in the Home status area
    property int iconSizeSmall: Theme.iconSizeSmall; // suits small icons, such as CoverAction icons and icons on the Events screen
    property int iconSizeSmallPlus: Theme.iconSizeSmallPlus; // a larger variant of iconSizeSmall, used for notification icons
    property int iconSizeMedium: Theme.iconSizeMedium; // the most common icon size; suits icons in small to medium-sized list items
    property int iconSizeLarge: Theme.iconSizeLarge; // suits larger icon displays and buttons
    property int iconSizeExtraLarge: Theme.iconSizeExtraLarge; // suits very large icon displays
    property int iconSizeLauncher: Theme.iconSizeLauncher; // for icons in the Home app grid

    // easier access to font size
    property int fontSizeXXSmall : Theme.fontSizeTiny;
    property int fontSizeXSmall : Theme.fontSizeExtraSmall;
    property int fontSizeSmall : Theme.fontSizeSmall;
    property int fontSizeMedium : Theme.fontSizeMedium;
    property int fontSizeLarge : Theme.fontSizeLarge;
    property int fontSizeXLarge : Theme.fontSizeExtraLarge;
    property int fontSizeXXLarge : Theme.fontSizeHuge;

    // icons
    property string iconDislike : "image://theme/icon-m-down";
    property string iconLike : "image://theme/icon-m-up";
    property string iconFavorite : "image://theme/icon-m-favorite";
    property string iconComments : "image://theme/icon-m-sms";
    property string iconReply : "image://theme/icon-m-add";
    property string iconDelete : "image://theme/icon-m-delete";
    property string iconRight: "image://theme/icon-m-right";
    property string iconLeft: "image://theme/icon-m-left";
    property string iconPlay: "image://theme/icon-m-play";
    property string iconSave: "image://theme/icon-m-download";
    property string iconInfo: "image://theme/icon-m-about";
    property string iconBrowser: "image://theme/icon-m-region";
    property string iconClipboard: "image://theme/icon-m-clipboard";
    property string iconUpload: "image://theme/icon-m-cloud-upload";
    property string iconPerson: "image://theme/icon-m-person";
    property string iconSearch: "image://theme/icon-m-search";
    property string iconLogo: "../images/sailimgur-logo_86x86.svg";

    // modes
    property string mode_main : "main";
    property string mode_user : "user";
    property string mode_random : "random";
    property string mode_score : "score";
    property string mode_memes : "memes";
    property string mode_favorites : "favorites";
    property string mode_albums : "albums";
    property string mode_images : "images";
}
