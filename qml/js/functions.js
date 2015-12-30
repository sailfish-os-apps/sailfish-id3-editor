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

function getSongs() {
    var songs = fce.songs();
    songs = songs.split("\n");
    songs.pop();
    console.log(songs);
    return songs;
}

function getSongInfo(path) {
    var props = ["title","album","artist","album_artist","release_date","track","track_count","disc","disc_count"];
    var songinfo = eyed3.songInfo(path);
    if(songinfo.indexOf("ID3") < 0) {
        console.log("no id3");
        return {title: ""};
    }
    var ret = {};
    songinfo = songinfo.split("\n");
    for (var i = 5; i < songinfo.length; i++) {
        var current = songinfo[i];
        console.log(current);
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
        if(current.indexOf("release date") > -1) {
            ret.release_date = current.replace("release date: ","");
        }
        if(current.indexOf("track: ") > -1) {
            var tr = current.replace("track: ","");
            if(tr.indexOf("/") > -1) {
                tr = tr.split("/");
                ret.track = tr[0];
                ret.track_count = tr[1];
            } else {
                ret.track = tr;
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
    }

    return ret;
}

function updateTextFields() {
    songtitle.text = info.title;
    songalbum.text = info.album;
    songartist.text = info.artist;
    songalbumartist.text = info.album_artist;
    songyear.text = info.release_date;
    songtracknumber.text = info.track;
    songtrackcount.text = info.track_count;
    songdiscnumber.text = info.disc;
    songdisccount.text = info.disc_count;
}
