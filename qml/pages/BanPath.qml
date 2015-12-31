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
                text: qsTr("If you add an path here, it will be ignored and won't search any mp3 files there.")
                wrapMode: Text.Wrap
                x: Theme.paddingLarge
            }
            TextField {
                id: path_ban
                label: qsTr("Path")
                placeholderText: qsTr("Path")
                width: page.width
            }
        }
    }
    onDone: {
        if (result == DialogResult.Accepted) {
            path = path_ban.text;
        }
    }
}
