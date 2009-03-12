module ScrewUnit
  module Representations
    class Spec < JsTestCore::Representations::Spec
      def title_text
        "Screw Unit suite"
      end
      
      def head_content
        js_files
        script(raw(<<-JS), :type => "text/javascript")
          (function($) {
            Screw.Assets = {};
            Screw.Assets.use_cache_buster = false; // TODO: NS/CTI - make this configurable from the UI.
            var required_paths = [];
            var included_stylesheets = {};
            var cache_buster = parseInt(new Date().getTime()/(1*1000));

            function tag(name, attributes) {
              var html = "<" + name;
              for(var attribute in attributes) {
                html += (" " + attribute + "='" + attributes[attribute]) + "'";
              };
              html += "></";
              html += name;
              html += ">";
              return html;
            }

            Screw.Assets.require = function(javascript_path, onload) {
              if(!required_paths[javascript_path]) {
                var full_path = javascript_path + ".js";
                if (Screw.Assets.use_cache_buster) {
                  full_path += '?' + cache_buster;
                }
                document.write(tag("script", {src: full_path, type: 'text/javascript'}));
                if(onload) {
                  var scripts = document.getElementsByTagName('script');
                  scripts[scripts.length-1].onload = onload;
                }
                required_paths[javascript_path] = true;
              }
            };

            Screw.Assets.stylesheet = function(stylesheet_path) {
              if(!included_stylesheets[stylesheet_path]) {
                var full_path = stylesheet_path + ".css";
                if(Screw.Assets.use_cache_buster) {
                  full_path += '?' + cache_buster;
                }
                document.write(tag("link", {rel: 'stylesheet', type: 'text/css', href: full_path}));
                included_stylesheets[stylesheet_path] = true;
              }
            };

            window.require = Screw.Assets.require;
            window.stylesheet = Screw.Assets.stylesheet;
          })(jQuery);

          (function($) {
            var ajax = $.ajax;
            $(Screw).bind('after', function() {
              var error_text = $(".error").map(function(i, element) {
                return element.innerHTML;
              }).get().join("\\n");

              ajax({
                type: "POST",
                url: '/session/finish',
                data: {"text": error_text}
              });
            });
          })(jQuery);
        JS
        link :rel => "stylesheet", :href => "/core/screw.css"
        
        spec_script_elements
      end

      def js_files
        script :src => jquery_js_file
        script :src => "/core/jquery.fn.js"
        script :src => "/core/jquery.print.js"
        script :src => "/core/screw.builder.js"
        script :src => "/core/screw.matchers.js"
        script :src => "/core/screw.events.js"
        script :src => "/core/screw.behaviors.js"
      end

      def jquery_js_file
        "/core/jquery-1.3.2.js"
      end

      def body_content
        div :id => "screw_unit_content"
      end
    end
  end
end