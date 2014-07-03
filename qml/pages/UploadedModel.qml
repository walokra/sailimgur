import QtQuick 2.0
import "../components/utils.js" as Utils
import "../components/storage.js" as Storage

ListModel {
    id: listModel;

    property string imgur_id : "";
    property string title : "";
    property string description : "";
    property string datetime;
    property string link : "";
    property string deletehash : "";

    function loadUploadedItems() {
        listModel.clear();

        var jsonObjects = Storage.readUploadedImageInfo();
        //console.log(JSON.stringify(jsonObjects));
        //console.log("item=" + jsonObjects.length);

        for(var i=0; i<jsonObjects.length; i++) {
            var data = JSON.parse(jsonObjects[i]);
            if (data !== "") {
                //console.log("data=" + JSON.stringify(data));
                var imageData = {
                    imgur_id: data.id,
                    title: data.title,
                    description: data.description,
                    datetime: data.datetime,
                    link: Utils.replaceURLWithHTMLLinks(data.link),
                    deletehash: data.deletehash
                };

                listModel.append(imageData);
            }
        }
    }

    function removeItem(imgur_id) {
        console.log("removeItem="+imgur_id);
        Storage.deleteUploadedImageInfo(imgur_id);
        for (var i = 0; i < listModel.count; i++) {
            if (listModel.get(i).imgur_id === imgur_id) {
                listModel.remove(i);
                break;
            }
        }
    }
}
