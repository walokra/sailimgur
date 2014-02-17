import QtQuick 2.0
import "../components/imgur.js" as Imgur

ListModel {
    id: listModel;

    property int index : 0;
    property var allComments : [];
    property bool loaded: false;

    function getComments(id) {
        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);

        Imgur.getGalleryComments(id, allComments,
                                 function(){
                                     loadingRectComments.visible = false;
                                     loaded = true;
                                     getNextComments();
                                 }, function(status, statusText) {
                                     loadingRectComments.visible = false;
                                     loaded = true;
                                     infoBanner.showHttpError(status, statusText);
                                 }
        );
    }

    function getNextComments() {
        var start = index * settings.commentsSlice;
        index += 1;
        var end = index * settings.commentsSlice;
        //start = (start >= allComments.length) ? allComments.length : start;
        //end = (end > allComments.length) ? allComments.length : end;
        //console.log("start=" + start + "; end=" + end + "; total=" + allComments.length);
        commentsModel.append(allComments.slice(start, end));
    }

}
