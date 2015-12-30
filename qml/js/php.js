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

function pathinfo(path, options) {

  var opt = '',
    optName = '',
    optTemp = 0,
    tmp_arr = {},
    cnt = 0,
    i = 0;
  var have_basename = false,
    have_extension = false,
    have_filename = false;

  if (!path) {
    return false;
  }
  if (!options) {
    options = 'PATHINFO_ALL';
  }


  var OPTS = {
    'PATHINFO_DIRNAME': 1,
    'PATHINFO_BASENAME': 2,
    'PATHINFO_EXTENSION': 4,
    'PATHINFO_FILENAME': 8,
    'PATHINFO_ALL': 0
  };

  for (optName in OPTS) {
    OPTS.PATHINFO_ALL = OPTS.PATHINFO_ALL | OPTS[optName];
  }
  if (typeof options !== 'number') {
    options = [].concat(options);
    for (i = 0; i < options.length; i++) {

      if (OPTS[options[i]]) {
        optTemp = optTemp | OPTS[options[i]];
      }
    }
    options = optTemp;
  }


  var __getExt = function(path) {
    var str = path + '';
    var dotP = str.lastIndexOf('.') + 1;
    return !dotP ? false : dotP !== str.length ? str.substr(dotP) : '';
  };

  if (options & OPTS.PATHINFO_DIRNAME) {
    var dirName = path.replace(/\\/g, '/')
      .replace(/\/[^\/]*\/?$/, ''); // dirname
    tmp_arr.dirname = dirName === path ? '.' : dirName;
  }

  if (options & OPTS.PATHINFO_BASENAME) {
    if (false === have_basename) {
      have_basename = this.basename(path);
    }
    tmp_arr.basename = have_basename;
  }

  if (options & OPTS.PATHINFO_EXTENSION) {
    if (false === have_basename) {
      have_basename = this.basename(path);
    }
    if (false === have_extension) {
      have_extension = __getExt(have_basename);
    }
    if (false !== have_extension) {
      tmp_arr.extension = have_extension;
    }
  }

  if (options & OPTS.PATHINFO_FILENAME) {
    if (false === have_basename) {
      have_basename = this.basename(path);
    }
    if (false === have_extension) {
      have_extension = __getExt(have_basename);
    }
    if (false === have_filename) {
      have_filename = have_basename.slice(0, have_basename.length - (have_extension ? have_extension.length + 1 :
        have_extension === false ? 0 : 1));
    }

    tmp_arr.filename = have_filename;
  }


  cnt = 0;
  for (opt in tmp_arr) {
    cnt++;
  }
  if (cnt == 1) {
    return tmp_arr[opt];
  }


  return tmp_arr;
}
