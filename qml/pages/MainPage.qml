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


Page {
    //property string api_key: API_KEY.get_key();
    property bool first_run: false
    property var songs
    property var banned_paths: false
    property string filter
    property bool debug: false
    property var parsed_songs

    id: page

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        PullDownMenu {

            MenuItem {
                text: qsTr("Turn off debug")
                visible: debug
                onClicked: {
                    DB.open().transaction(function(tx) {
                        tx.executeSql("UPDATE debug SET debug=0");
                        debug = false;
                    });
                }
            }

            MenuItem {
                text: qsTr("Delete databases")
                visible: debug
                onClicked: {
                    DB.open().transaction(function(tx) {
                        tx.executeSql("DROP TABLE IF EXISTS firstrun");
                        tx.executeSql("DROP TABLE IF EXISTS banned");
                    });
                }
            }

            MenuItem {
                text: qsTr("Ban path")
                onClicked: {
                    var dialog = pageStack.push("BanPath.qml");
                    dialog.accepted.connect(function() {
                        DB.open().transaction(function(tx) {
                            tx.executeSql("INSERT INTO banned (path) VALUES (?)",dialog.path);
                        });
                    });
                }
            }

            MenuItem {
                text: search.visible?qsTr("Hide search field"):qsTr("Show search field")
                onClicked: {
                    search.visible = !search.visible;
                    if(!search.visible) {
                        search.text = "";
                        search.focus = false;
                    } else {
                        search.focus = true;
                    }
                }
            }
        }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Choose song")
            }
            WorkerScript {
                id: myWorker
                source: "../js/workerscript.js"
                onMessage: {
                    if(typeof messageObject.res != "undefined") { // first time loading
                        var parsed_songs = messageObject.res;
                        Functions.reloadSongList();
                        loading.visible = false;
                    }
                    if(typeof messageObject.filtered != "undefined") {
                        var songs = messageObject.filtered;
                        for(var i in songs) {
                            var m_text = PHP.pathinfo(songs[i],'PATHINFO_BASENAME');
                            var m_path = songs[i];
                            lmodel.append({m_text: m_text, m_path: m_path});
                        }
                        loading.visible = false;
                    }
                }
            }

            ListModel {
                id: lmodel
            }

            TextField {
                width: parent.width - Theme.paddingLarge * 2
                x: Theme.paddingLarge
                id: search
                visible: false
                placeholderText: qsTr("Search...")
                label: qsTr("Search...")
                onTextChanged: {
                    //Functions.reloadSongList(search.text);
                    lmodel.clear();
                    loading.visible = true;
                    myWorker.sendMessage({parsed_songs: parsed_songs, filter: search.text, banned_paths: banned_paths});
                }
            }

            Label {
                id: loading
                visible: true
                text: qsTr("Loading...")
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }


            Repeater {
                visible: false
                id: listview
                model: lmodel
                Button {
                    height: 70
                    width: page.width
                    text: m_text
                    fontsize: Theme.fontSizeExtraSmall
                    onClicked: {
                        var dialog = pageStack.push("SongDetail.qml",{path: m_path});
                        dialog.accepted.connect(function() {
                            eyed3.updateSong(dialog.command);
                        });
                    }
                }
            }

            Timer {
                id: starttimer
                running: true
                interval: 500
                onTriggered: {
                    if(banned_paths) {
                        starttimer.running = false;
                        myWorker.sendMessage({songs: fce.songs(), banned_paths: banned_paths});
//                        Functions.reloadSongList();
                        /*songs = Functions.getSongs("Rammstein");
                        /*for(var j in banned_paths) {
                            var banned = banned_paths[j];
                            for(var i = songs.length - 1; i >= 0; i--) {
                                var song = songs[i];
                                if(song.indexOf(banned) > -1) {
                                    songs.splice(i,1);
                                }
                            }
                        }
                        for(var i in songs) {
                            var m_text = PHP.pathinfo(songs[i],'PATHINFO_BASENAME');
                            var m_path = songs[i];
                            lmodel.append({m_text: m_text, m_path: m_path});
                        }*/
                    }
                }
            }

            Component.onCompleted: {
                myWorker.sendMessage({songs: fce.songs()});
                DB.open().transaction(function(tx) {

                    //tx.executeSql("DROP TABLE IF EXISTS firstrun");
                    //tx.executeSql("DROP TABLE IF EXISTS banned");

                    tx.executeSql("CREATE TABLE IF NOT EXISTS firstrun (firstrun INT)")
                    tx.executeSql("CREATE TABLE IF NOT EXISTS banned (path TEXT)");
                    tx.executeSql("CREATE TABLE IF NOT EXISTS debug (debug INT)");
                    var res = tx.executeSql("SELECT * FROM firstrun");
                    if(!res.rows.length) { // it's first time running this app
                        console.log("firstrun");
                        tx.executeSql("INSERT INTO firstrun (firstrun) VALUES (1)");
                        first_run = true;
                    } else {
                        console.log("notfirstrun");
                        first_run = false;
                    }

                    res = tx.executeSql("SELECT * FROM banned");
                    if(!res.rows.length) {
                        banned_paths = true;
                    } else {
                        banned_paths = [];
                        for(var i = 0; i < res.rows.length; i++) {
                            banned_paths[i] = res.rows.item(i).path;
                        }
                        console.log(banned_paths);
                    }

                    res = tx.executeSql("SELECT * FROM debug");
                    if(res.rows.length) {
                        debug = res.rows.item(0).debug == 1?true:false;
                    } else {
                        tx.executeSql("INSERT INTO debug (debug) VALUES (0)");
                    }
                    console.log(debug);

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


