// http://qt-project.org/doc/qt-5.0/qtquick/qmlmodule-qtquick-localstorage2-qtquick-localstorage-2.html

.import QtQuick.LocalStorage 2.0 as LS

var db = null;
var identifier = "Sailimgur";
var version = "1.0";
var description = "LSDB";

/**
  Connect to database and create table if not exists.
*/
function connect() {
    db = LS.LocalStorage.openDatabaseSync(identifier, version, description, 10240);

    // Create settings table (key, value)
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS settings(key TEXT PRIMARY KEY, value TEXT);");
    });

    return db;
}

/**
  Get all settings.
*/
function getAllSettings() {
    var res = {};
    db.readTransaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM Settings;')
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
  Save setting to database.
*/
function setSetting(key, value) {
    if (value === true) {
        value = 'true';
    }
    else if (value === false) {
        value = 'false';
    }

    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?, ?);", [key, value]);
        tx.executeSql("COMMIT;");
    });
}

/**
 Get given setting from database.
*/
function getSetting(key, defaultValue) {
    var setting = null;

    db.readTransaction(function(tx) {
        var rows = tx.executeSql("SELECT value AS val FROM settings WHERE key=?;", [key]);

        if (rows.rows.length !== 1) {
            setting = null;
        } else {
            setting = rows.rows.item(0).val;
        }
    });

    if (setting === 'true') {
        return true;
    }
    else if (setting === 'false') {
        return false;
    }
    else if (setting === null) {
        return defaultValue;
    }

    return setting;
}
