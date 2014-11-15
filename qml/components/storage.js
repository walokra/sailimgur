.pragma library
.import QtQuick.LocalStorage 2.0 as LS

Qt.include("../lib/aes.js");

var identifier = "Sailimgur";
var description = "Sailimgur database";

var QUERY = {
    CREATE_SETTINGS_TABLE: 'CREATE TABLE IF NOT EXISTS settings(key TEXT PRIMARY KEY, value TEXT);',
    CREATE_UPLOADS_TABLE: 'CREATE TABLE IF NOT EXISTS uploads(key TEXT PRIMARY KEY, value TEXT);'
}

/**
  Open app's database, create it if not exists.
*/
var db = LS.LocalStorage.openDatabaseSync(identifier, "", description, 1000000, function(db) {
    db.changeVersion(db.version, "1.0", function(tx) {
        // Create settings table (key, value)
        tx.executeSql(QUERY.CREATE_SETTINGS_TABLE);
        // Create uploads table
        tx.executeSql(QUERY.CREATE_UPLOADS_TABLE);
    });
});

/**
    Reset
*/
function reset() {
    db.transaction(function(tx) {
        tx.executeSql("DROP TABLE IF EXISTS settings;");
        //tx.executeSql("DROP TABLE IF EXISTS uploads;");
        tx.executeSql(QUERY.CREATE_SETTINGS_TABLE);
        tx.executeSql("COMMIT;");
    });
}

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
            //console.log("key=" + rs.rows.item(i).key + "; value=" + rs.rows.item(i).value);
        }
    });
    return res;
}

/**
  Write setting to database.
*/
function writeSetting(key, value) {
    //console.log("writeSetting(" + key + "=" + value + ")");

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
 Read given setting from database.
*/
function readSetting(key) {
    //console.log("readSetting(" + key + ")");

    var res = "";
    db.readTransaction(function(tx) {
        var rows = tx.executeSql("SELECT value AS val FROM settings WHERE key=?;", [key]);

        if (rows.rows.length !== 1) {
            res = "";
        } else {
            res = rows.rows.item(0).val;
        }
    });

    if (res === 'true') {
        return true;
    }
    else if (res === 'false') {
        return false;
    }

    return res;
}

/**
  Write token to database.
*/
function writeToken(key, value, passphrase) {
    //console.log("writeToken(" + key + "=" + value + "; " + passphrase + ")");
    if (value !== "" && passphrase !== "") {
        db.transaction(function(tx) {
            var wa = CryptoJS.AES.encrypt(value, passphrase);
            var encrypted = wa.toString();
            //console.log("key=" + key + "; value=" + value + "; enc=" + encrypted);
            tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?, ?);", [key, encrypted]);
            tx.executeSql("COMMIT;");
        });
    }
}

/**
 Read token from database.
*/
function readToken(key, passphrase) {
    //console.log("readToken(" + key + "; "+ passphrase + ")");

    var res = "";
    var decrypted = "";
    db.readTransaction(function(tx) {
        var rows = tx.executeSql("SELECT value AS val FROM settings WHERE key=?;", [key]);

        if (rows.rows.length !== 1) {
            res = "";
        } else {
            res = rows.rows.item(0).val;
            if (!res || res === "") {
                return res;
            }
            var wa = CryptoJS.AES.decrypt(res, passphrase);
            decrypted = wa.toString(CryptoJS.enc.Utf8);
        }
    });

    return decrypted;
}

/**
  Write uploaded image info to database.
*/
function writeUploadedImageInfo(key, value) {
    //console.log("storage.js: writeUploadedImageInfo=" + JSON.stringify(value));
    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO uploads VALUES (?, ?);", [key, JSON.stringify(value)]);
        tx.executeSql("COMMIT;");
    });
}

/**
  Delete uploaded image info from database.
*/
function deleteUploadedImageInfo(key) {
    //console.log("storage.js: deleteUploadedImageInfo=" + key);
    db.transaction(function(tx) {
        tx.executeSql("DELETE FROM uploads WHERE key=?;", [key]);
        tx.executeSql("COMMIT;");
    });
}

/**
 Read uploaded images info from database.
*/
function readUploadedImageInfo() {
    var res = [];
    db.readTransaction(function(tx) {
        var rows = tx.executeSql("SELECT * FROM uploads");
        //console.log("rows=" + JSON.stringify(rows));

        for (var i=0; i<rows.rows.length; i++) {
            res[i] = rows.rows.item(i).value;
            //console.log("key=" + rs.rows.item(i).key + "; value=" + rs.rows.item(i).value);
        }
    });

    return res;
}
