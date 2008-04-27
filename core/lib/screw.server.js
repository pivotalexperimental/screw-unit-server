var Assets = {
  require: function(path_from_javascripts, onload) {
    if(!Assets.required_paths[path_from_javascripts]) {
      var full_path = path_from_javascripts + ".js";
      if (Assets.use_cache_buster) {
        full_path += '?' + Assets.cache_buster;
      }
      document.write("<script src='" + full_path + "' type='text/javascript'></script>");
      if(onload) {
        var scripts = document.getElementsByTagName('script');
        scripts[scripts.length-1].onload = onload;
      }
      Assets.required_paths[path_from_javascripts] = true;
    }
  },

  stylesheet: function(path_from_stylesheets) {
    if(!Assets.included_stylesheets[path_from_stylesheets]) {
      var full_path = path_from_stylesheets + ".css";
      if(Assets.use_cache_buster) {
        full_path += '?' + Assets.cache_buster;
      }
      document.write("<link rel='stylesheet' type='text/css' href='" + full_path + "' />");
      Assets.included_stylesheets[path_from_stylesheets] = true;
    }
  },

  required_paths: {},
  included_stylesheets: {},
  use_cache_buster: false, // TODO: NS/CTI - make this configurable from the UI.
  cache_buster: parseInt(new Date().getTime()/(1*1000))
}
var require = Assets.require;
var stylesheet = Assets.stylesheet;
