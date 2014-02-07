// http://qt-project.org/doc/qt-5.0/qtquick/qmlmodule-qtquick-localstorage2-qtquick-localstorage-2.html

.pragma library
.import QtQuick.LocalStorage 2.0 as LS

var identifier = "Sailimgur";
var version = "1.0";
var description = "Sailimgur database";

var db = LS.LocalStorage.openDatabaseSync(identifier, version, description, 10240, function(db) {
    // Create settings table (key, value)
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT);");
    });
});

/**
  Read all settings.
*/
function readAllSettings() {
    var res = {};
    db.readTransaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM settings;')
        for (var i=0; i<rs.rows.length; i++) {
            if (rs.rows.item(i).value === 'true') {
                res[rs.rows.item(i).key] = true;
            }
            else if (rs.rows.item(i).value === 'false') {
                res[rs.rows.item(i).key] = false;
            } else {
                res[rs.rows.item(i).key] = rs.rows.item(i).value
            }
        }
    });
    return res;
}

/**
  Write setting to database.
*/
function writeSetting(settings) {
    db.transaction(function(tx) {
        for (var s in settings) {
            tx.executeSql('INSERT OR REPLACE INTO settings VALUES(?,?);', [s, settings[s]])
        }
    });
}

/**
 Read given setting from database.
*/
function readSetting(setting) {
    var res = "";
    db.readTransaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM settings WHERE key=?;', [setting])
        if (rs.rows.length > 0) res = rs.rows.item(0).value
    });
    return res;
}
