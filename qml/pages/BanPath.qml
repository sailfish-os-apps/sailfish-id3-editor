import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
//import "../js/api_key.js" as API_KEY // this file is in .gitignore and contains only one function, get_key(), which just returns the api key
import "../js/DB.js" as DB
import "../js/LastFM.js" as LastFM
import "../js/functions.js" as Functions
import "../js/eyeD3.js" as EyeD3
import "../js/php.js" as PHP
import "components"

Dialog {
    property var path
    property int clicked_times: 0
    id: page
    SilicaFlickable {
        anchors.fill: parent
        id: flickable
        contentHeight: maincolumn.height
        Column {
            id: maincolumn
            width: page.width
            DialogHeader {
                cancelText: qsTr("Cancel")
                acceptText: qsTr("Save")
            }

            PageHeader {
                title: qsTr("Write path")
            }
            Label {
                width: page.width - Theme.paddingLarge * 2
                text: qsTr("If you add a path here, it will be ignored and won't search any mp3 files there.")
                wrapMode: Text.Wrap
                x: Theme.paddingLarge
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        clicked_times++;
                        console.log(clicked_times);
                        if(clicked_times >= 10) {
                            DB.open().transaction(function(tx) {
                                tx.executeSql("UPDATE debug SET debug=1");
                            });
                        }
                    }
                }
            }
            TextField {
                id: path_ban
                label: qsTr("Path")
                placeholderText: qsTr("Path")
                width: page.width
            }
            ListModel {
                id: lmodel
            }

            Repeater {
                id: listview
                model: lmodel
                Label {
                    text: m_path
                    x: Theme.paddingLarge + 70
                    truncationMode: TruncationMode.Fade
                    width: page.width - Theme.paddingLarge * 2 - 70 - Theme.paddingLarge
                    height: 70
                    verticalAlignment: Text.AlignVCenter
                    Button {
                        width: 70
                        height: 70
                        radius: 35
                        anchors.right: parent.left
                        anchors.rightMargin: Theme.paddingLarge
                        Image {
                            source: "image://theme/icon-close-vkb"
                            width: 32
                            height: 32
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            DB.open().transaction(function(tx) {
                                tx.executeSql("DELETE FROM banned WHERE path='"+m_path+"'");
                            });
                            visible = false;
                            parent.visible = false;
                        }
                    }
                }
            }
        }
        Component.onCompleted: {
            DB.open().transaction(function(tx) {
                var res = tx.executeSql("SELECT * FROM banned");
                if(res.rows.length) {
                    for(var i = 0; i < res.rows.length; i++) {
                        lmodel.append({m_path: res.rows.item(i).path});
                    }
                }
            });
        }
    }
    onDone: {
        if (result == DialogResult.Accepted) {
            path = path_ban.text;
        }
    }
}
