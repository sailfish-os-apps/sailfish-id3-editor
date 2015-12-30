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
    var props = ["title","album","artist","album_artist","release_date","track","track_count","disc","disc_count","genre"];
    var songinfo = eyed3.songInfo(path);
    if(songinfo.indexOf("ID3") < 0) {
        console.log("no id3");
        return {title: ""};
    }
    var ret = {};
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
    songgenre.text = info.genre;
}

function saveSong(path) {
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

    return command;
}
