WorkerScript.onMessage = function(message) {
    if(typeof message.songs != "undefined") {
        var songs = message.songs;
        var banned_paths = message.banned_paths;
        var result = getSongs(songs,banned_paths);
        console.log("result ready");
        WorkerScript.sendMessage({res: result});
    }
    if(typeof message.filter != "undefined") {
        var filter = message.filter;
        var parsed_songs = message.parsed_songs;
        var banned_paths = message.banned_paths;
        var result = filter_songs(parsed_songs,filter,banned_paths);
        WorkerScript.sendMessage({filtered: result});
    }
};

function getSongs(songs,banned_paths) {
    songs = songs.split("\n");
    songs.pop();
    for(var j in banned_paths) {
        var banned = banned_paths[j];
        for(var i = songs.length - 1; i >= 0; i--) {
            var song = songs[i];
            if(song.indexOf(banned) > -1) {
                songs.splice(i,1);
            }
        }
    }
    return songs;
}

function filter_songs(songs,filter, banned_paths) {

    for(var j in banned_paths) {
        var banned = banned_paths[j];
        for(var i = songs.length - 1; i >= 0; i--) {
            var song = songs[i];
            if(song.indexOf(banned) > -1) {
                songs.splice(i,1);
            }
        }
    }

    if(!filter) {
        console.log("filtered result ready");
        return songs;
    }

    var r_songs = [];
    for(var i in songs) {
        var song = basename(songs[i]);
        var reg = new RegExp(filter,"i");
        if(reg.test(song)) {
            r_songs.push(songs[i]);
        }
    }
    console.log("filtered result ready");
    return r_songs;
}

function basename(path, suffix) {
  var b = path;
  var lastChar = b.charAt(b.length - 1);

  if (lastChar === '/' || lastChar === '\\') {
    b = b.slice(0, -1);
  }

  b = b.replace(/^.*[\/\\]/g, '');

  if (typeof suffix === 'string' && b.substr(b.length - suffix.length) == suffix) {
    b = b.substr(0, b.length - suffix.length);
  }

  return b;
}
