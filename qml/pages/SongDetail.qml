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
    property string path
    property var info
    property string command
    property string type // mp3 or ogg

    id: page
    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: maincolumn.height

        /*PullDownMenu {

            MenuItem {
                text: qsTr("Save");
                onClicked: {
                    Functions.saveSong(path);
                }
            }
        }*/

        Column {
            id: maincolumn
            width: page.width

            DialogHeader {
                id: dialogheader
                acceptText: qsTr("Save")
                cancelText: qsTr("Cancel")
            }

            PageHeader {
                id: title
                title: qsTr("Edit song tags")
            }

            Label {
                id: baseinfo
                font.pixelSize: Theme.fontSizeSmall
                width: page.width - 2 * Theme.paddingLarge
                x: Theme.paddingLarge
                Component.onCompleted: {
                    var songname = PHP.pathinfo(path,'PATHINFO_FILENAME');
                    var songpath = PHP.pathinfo(path,'PATHINFO_DIRNAME');
                    baseinfo.text = qsTr("Song file name: %1\nSong path: %2").arg(songname).arg(songpath);
                    type = Functions.getType();
                    info = Functions.getSongInfo(path);
                    Functions.updateTextFields();
                }
            }

            Item {
                width: parent.width
                height: 80
            }

            TextField {
                id: songartist
                width: parent.width
                label: qsTr("Artist")
                placeholderText: qsTr("Artist")
            }

            TextField {
                id: songtitle
                width: parent.width
                label: qsTr("Title")
                placeholderText: qsTr("Song title");
            }

            TextField {
                id: songalbum
                width: parent.width
                label: qsTr("Album")
                placeholderText: qsTr("Album")
            }

            TextField {
                id: songalbumartist
                width: parent.width
                visible: type == "mp3"
                label: qsTr("Album artist")
                placeholderText: qsTr("Album artist")
            }

            TextField {
                id: songtracknumber
                width: parent.width
                label: qsTr("Track number")
                placeholderText: qsTr("Track number")
                inputMethodHints: Qt.ImhDigitsOnly
            }

            TextField {
                id: songtrackcount
                width: parent.width
                visible: type == "mp3"
                label: qsTr("Total tracks on album")
                placeholderText: qsTr("Total tracks on album")
                inputMethodHints: Qt.ImhDigitsOnly
            }

            TextField {
                id: songdiscnumber
                width: parent.width
                visible: type == "mp3"
                label: qsTr("Disc number")
                placeholderText: qsTr("Disc number")
                inputMethodHints: Qt.ImhDigitsOnly
            }

            TextField {
                id: songdisccount
                width: parent.width
                visible: type == "mp3"
                label: qsTr("Total discs count")
                placeholderText: qsTr("Total discs count")
                inputMethodHints: Qt.ImhDigitsOnly
            }

            TextField {
                id: songgenre
                width: parent.width
                label: qsTr("Genre")
                placeholderText: qsTr("Genre")
            }

            TextField {
                id: songyear
                width: parent.width
                label: qsTr("Year")
                placeholderText: qsTr("Year")
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }
    }
    onDone: {
        if (result == DialogResult.Accepted) {
            command = Functions.saveSong(path);
        }
    }
}
