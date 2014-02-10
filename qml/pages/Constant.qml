import QtQuick 2.0
import Sailfish.Silica 1.0

QtObject {
    id: constant;

    property string appName : "Sailimgur";

    // imgur API key/secret
    // The OAuth2 key/secret pair below are only for testing
    // Release version in Jolla Store / OpenRepos has a different key pair
    property string clientId : "f6e8f7a754f7266";
    property string clientSecret : "";

    property string userAgent : appName + " " + APP_VERSION + "-" + APP_RELEASE + "(Jolla; Qt; SailfishOS)";

    property int commentPointsLimit : 1;

    // easier access to colors
    property color colorHighlight : Theme.highlightColor;
    property color colorPrimary : Theme.primaryColor;
    property color colorSecondary : Theme.secondaryColor;
    property color colorHilightSecondary : Theme.secondaryHighlightColor;

    // easier access to padding size
    property int paddingSmall : Theme.paddingSmall;
    property int paddingMedium : Theme.paddingMedium;
    property int paddingLarge : Theme.paddingLarge;

    // easier access to font size
    property int fontSizeXXSmall : Theme.fontSizeTiny;
    property int fontSizeXSmall : Theme.fontSizeExtraSmall;
    property int fontSizeSmall : Theme.fontSizeSmall;
    property int fontSizeMedium : Theme.fontSizeMedium;
    property int fontSizeLarge : Theme.fontSizeLarge;
    property int fontSizeXLarge : Theme.fontSizeExtraLarge;
    property int fontSizeXXLarge : Theme.fontSizeHuge;

    // icons
    property string iconDislike : "../images/icons/dislike.svg";
    property string iconDisliked : "../images/icons/disliked.svg";
    property string iconLike : "../images/icons/like.svg";
    property string iconLiked : "../images/icons/liked.svg";
    property string iconFavorite : "../images/icons/favorite.svg";
    property string iconFavorited : "../images/icons/favorited.svg";
}
