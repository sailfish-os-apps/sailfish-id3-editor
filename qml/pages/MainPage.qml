import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../js/api_key.js" as API_KEY // this file is in .gitignore and contains only one function, get_key(), which just returns the api key
import "../js/DB.js" as DB
import "../js/LastFM.js" as LastFM
import "../js/functions.js" as Functions


Page {
    property string api_key: API_KEY.get_key();
    property bool first_run: false
    id: page

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("UI Template")
            }
            Label {
                x: Theme.paddingLarge
                text: eyed3.whoami()
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }

            Component.onCompleted: {
                DB.open().transaction(function(tx) {

                    //tx.executeSql("DROP TABLE IF EXISTS firstrun");


                    tx.executeSql("CREATE TABLE IF NOT EXISTS firstrun (firstrun INT)")
                    var res = tx.executeSql("SELECT * FROM firstrun");
                    if(!res.rows.length) { // it's first time running this app
                        console.log("firstrun");
                        tx.executeSql("INSERT INTO firstrun (firstrun) VALUES (1)");
                        first_run = true;
                    } else {
                        console.log("notfirstrun");
                        first_run = false;
                    }

                    if(first_run) {
                        if(!Functions.installEyeD3()) {
                            console.log("error");
                        }
                    }
                });
            }
        }
    }
}


