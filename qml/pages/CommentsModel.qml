import QtQuick 2.0
import "../components/imgur.js" as Imgur

ListModel {
    id: listModel;

    property int index : 0;
    property var allComments : [];
    property int total : 0;
    property int left : 0;
    property bool loaded: false;
    property bool showNsfw: settings.showNsfw;

    function resetVariables() {
        index = 0;
        total = 0;
        left = 0;
        allComments = [];
        loaded = false;
    }

    function getComments(id) {
        Imgur.init(constant.clientId, constant.clientSecret, settings.accessToken, settings.refreshToken, constant.userAgent);

        resetVariables();
        listModel.clear();

        Imgur.getGalleryComments(id, allComments,
                                 function(){
                                     loadingRectComments.visible = false;
                                     loaded = true;
                                     total = allComments.length;
                                     left = total;
                                     getNextComments();
                                 }, function(status, statusText) {
                                     loadingRectComments.visible = false;
                                     loaded = true;
                                     total = 0;
                                     left = 0;
                                     infoBanner.showHttpError(status, statusText);
                                 }
        );
    }

    function getNextComments() {
        var start = index * settings.commentsSlice;
        index += 1;
        var end = index * settings.commentsSlice;
        listModel.append(allComments.slice(start, end));
        left = total - end;
//        console.log("getNextComments, start=" + start + "; end=" + end + "; left=" + left + "; total=" + total + "; allComments=" + allComments.length);
    }

    function getComment(id) {
        var commentArr = [];
        Imgur.getComment(id, commentArr, function () {
                //console.log("data=" + JSON.stringify(commentArr));

                for (var i = 0; i < listModel.count; i++) {
                    //console.log("listModel.get(i).id=" + listModel.get(i).id + "; id=" + id);
                    if (listModel.get(i).id === id) {
                        //console.log("i=" + i);
                        listModel.set(i, commentArr[0]);
                        break;
                    }
                }
            },function(status, statusText) {
                infoBanner.showHttpError(status, statusText);
            }
        );
    }

    function commentCreate(imgur_id, id, text, onSuccess) {
        Imgur.commentCreation(imgur_id, text, id,
              function (data) {
                  getComments(imgur_id);
                  onSuccess(data);
              },
              function(status, statusText) {
                  infoBanner.showHttpError(status, statusText);
              }
        );
    }

    function commentDelete(id) {
        Imgur.commentDeletion(id,
            function (data) {
                //console.log("data=" + JSON.stringify(data));
                for (var i = 0; i < commentsModel.count; i++) {
                    if (commentsModel.get(i).id === id) {
                        commentsModel.remove(i);
                        break;
                    }
                }
                infoBanner.showText("Comment deleted!");
            },
            function(status, statusText) {
                infoBanner.showHttpError(status, statusText);
            }
        );
    }

    function commentVote(id, vote) {
        Imgur.commentVote(id, vote,
            function (data) {
                if (vote === "up") {
                    infoBanner.showText("Comment liked!");
                } else if (vote === "up") {
                    infoBanner.showText("Comment disliked!");
                }

                // Refresh comment
                if (listModel) {
                    getComment(id);
                }
                //
            },
            function(status, statusText) {
                infoBanner.showHttpError(status, statusText);
            }
        );
    }

}
