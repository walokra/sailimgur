.pragma library
.import QtQuick.LocalStorage 2.0 as LS

Qt.include("../lib/aes.js");

var identifier = "Sailimgur";
var version = "1.0";
var description = "Sailimgur database";

/**
  Open app's database, create it if not exists.
*/
var db = null;

/**
  Open app's database, create it if not exists.
*/
function connect() {
    var db = LS.LocalStorage.openDatabaseSync(identifier, version, description, 10240);

    // Create settings table (key, value)
    db.transaction(function(tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS settings(key TEXT PRIMARY KEY, value TEXT);");
    });

    return db;
}

/**
  Read all settings.
*/
function readAllSettings(db) {
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
function writeSetting(db, key, value) {
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
function readSetting(db, key) {
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
function writeToken(db, key, value, passphrase) {
    //console.log("writeToken(" + key + "=" + value + "; " + passphrase + ")");
    db.transaction(function(tx) {
        var wa = CryptoJS.AES.encrypt(value, passphrase);
        var encrypted = wa.toString();
        //console.log("key=" + key + "; value=" + value + "; enc=" + encrypted);
        tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?, ?);", [key, encrypted]);
        tx.executeSql("COMMIT;");
    });
}

/**
 Read token from database.
*/
function readToken(db, key, passphrase) {
    //console.log("readToken(" + key + "=" + value + "; "+ passphrase + ")");

    var res = "";
    var decrypted = "";
    db.readTransaction(function(tx) {
        var rows = tx.executeSql("SELECT value AS val FROM settings WHERE key=?;", [key]);

        if (rows.rows.length !== 1) {
            res = "";
        } else {
            res = rows.rows.item(0).val;
            if (res === "") {
                return res;
            }
            var wa = CryptoJS.AES.decrypt(res, passphrase);
            decrypted = wa.toString(CryptoJS.enc.Utf8);
        }
    });

    return decrypted;
}
