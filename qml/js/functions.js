function installEyeD3() {
    if(!eyed3.check()) {
        eyed3.untar();
        console.log("Untared");
        eyed3.install();
        eyed3.deleteCompileDir();
        return eyed3.check();
    }
    return true;
}

function reloadSongList(filter) {
    lmodel.clear();
    songs = getSongs(filter);
    for(var j in banned_paths) {
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
    }
}

function getSongs(filter) {
    var songs;
    if(parsed_songs) {
        songs = parsed_songs;
    } else {
        songs = fce.songs();
        songs = songs.split("\n");
        songs.pop();
        parsed_songs = songs;
    }
    if(!filter) {
        return songs;
    }
    var r_songs = [];
    for(var i in songs) {
        var song = PHP.basename(songs[i]);
        console.log(song);
        var reg = new RegExp(filter,"i");
        if(reg.test(song)) {
            r_songs.push(songs[i]);
        }
    }
    return r_songs;
}

function getSongInfo(path) {
    var ret = {};
    if(type == "mp3") {
        var props = ["title","album","artist","album_artist","release_date","track","track_count","disc","disc_count","genre"];
        var songinfo = eyed3.songInfo(path);
        if(songinfo.indexOf("ID3") < 0) {
            console.log("no id3");
            return {title: ""};
        }
        songinfo = songinfo.split("\n");
        for (var i = 5; i < songinfo.length; i++) {
            var current = songinfo[i];
            //console.log(current);
            if(current.indexOf("title") > -1) {
                ret.title = current.replace("title: ","");
            }
            if(current.indexOf("album") > -1 && current.indexOf("artist") < 0) {
                ret.album = current.replace("album: ","");
            }
            if(current.indexOf("artist") > -1 && current.indexOf("album") < 0) {
                ret.artist = current.replace("artist: ","");
            }
            if(current.indexOf("album artist") > -1) {
                ret.album_artist = current.replace("album artist: ","");
            }
            if(current.indexOf("release date") > -1 && current.indexOf("original") < 0) {
                ret.release_date = current.replace("release date: ","");
            }
            if(current.indexOf("track: ") > -1) {
                //var tr = current.replace("track: ","");
                var tr = current.match(/^track: ([0-9]{1,3})\/?([0-9]{1,3})?.*$/);
                if(typeof tr != "undefined" && tr) {
                    if(tr[1]) {
                        ret.track = tr[1];
                    }
                    if(tr[2]) {
                        ret.track_count = tr[2];
                    }
                }
            }
            if(current.indexOf("disc: ") > -1) {
                var tr = current.replace("disc: ","");
                if(tr.indexOf("/") > -1) {
                    tr = tr.split("/");
                    ret.disc = tr[0];
                    ret.disc_count = tr[1];
                } else {
                    ret.disc = tr;
                }
            }

            if(current.indexOf("genre: ") > -1) {
                var curr = current+" (";
                console.log(curr);
                var tr = curr.match(/genre: (.+?) \(/);
                ret.genre = tr[1];
            }
        }

        for(var j in props) {
            if(typeof ret[props[j]] === "undefined") {
                ret[props[j]] = "";
            }

        }
    } else if(type == "ogg") {
        var songinfo = ogg.songInfo(path);
        songinfo = songinfo.split("|||");
        ret.title = songinfo[0] != "none"?songinfo[0]:"";
        ret.artist = songinfo[1] != "none"?songinfo[1]:"";
        ret.album = songinfo[2] != "none"?songinfo[2]:"";
        ret.genre = songinfo[3] != "none"?songinfo[3]:"";
        ret.release_date = songinfo[4] != "none"?songinfo[4]:"";
        ret.track = songinfo[5] != "none"?songinfo[5]:"";
    }

    return ret;
}

function updateTextFields() {
    songtitle.text = info.title;
    songalbum.text = info.album;
    songartist.text = info.artist;   
    songyear.text = info.release_date;
    songtracknumber.text = info.track;    
    songgenre.text = info.genre;

    if(type == "mp3") {
        songalbumartist.text = info.album_artist;
        songtrackcount.text = info.track_count;
        songdiscnumber.text = info.disc;
        songdisccount.text = info.disc_count;
    }
}

function saveSong(path) {
    if(type == "mp3") {
        var command = "eyeD3 ";
        command += '--title "'+(songtitle.text?songtitle.text:"")+'" ';
        command += '--album "'+(songalbum.text?songalbum.text:"")+'" ';
        command += '--artist "'+(songartist.text?songartist.text:"")+'" ';
        command += '--album-artist "'+(songalbumartist.text?songalbumartist.text:"")+'" ';
        command += '--release-year '+(songyear.text?songyear.text:0)+' ';
        command += '-n '+(songtracknumber.text?songtracknumber.text:0)+' ';
        command += '-N '+(songtrackcount.text?songtrackcount.text:0)+' ';
        command += '-d '+(songdiscnumber.text?songdiscnumber.text:0)+' ';
        command += '-D '+(songdisccount.text?songdisccount.text:0)+' ';
        command += '-G "'+(songgenre.text?songgenre.text:"")+'" ';
        command += '"'+path+'"';
    } else {
        var command = "/usr/share/harbour-id3-editor/bin -edit "+'"'+path+'" ';
        command += '-t "'+(songtitle.text?songtitle.text:"")+'" ';
        command += '-A "'+(songalbum.text?songalbum.text:"")+'" ';
        command += '-a "'+(songartist.text?songartist.text:"")+'" ';
        command += '-y '+(songyear.text?songyear.text:0)+' ';
        command += '-T '+(songtracknumber.text?songtracknumber.text:0)+' ';
        command += '-g "'+(songgenre.text?songgenre.text:"")+'"';
    }
    //console.log(command);
    return command;
}

function getType() {
    var type;
    if(path.indexOf(".mp3") > -1) {
        type = "mp3";
    } else if(path.indexOf(".ogg") > -1) {
        type = "ogg";
    }
    return type;
}
