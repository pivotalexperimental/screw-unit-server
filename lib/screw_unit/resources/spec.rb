module ScrewUnit
  module Resources
    module Spec
      def get
        # TODO: BT/JN - Remove the Screw.Assets when we implement rendering of script and link tags from yml files.
        html = <<-HTML
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
        <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>ScrewUnit results</title>
        <script src="/core/jquery-1.2.6.js"></script>
        <script src="/core/jquery.fn.js"></script>
        <script src="/core/jquery.print.js"></script>
        <script src="/core/screw.builder.js"></script>
        <script src="/core/screw.matchers.js"></script>
        <script src="/core/screw.events.js"></script>
        <script src="/core/screw.behaviors.js"></script>
        <script type="text/javascript">
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

              var session_id;
              if(top.runOptions) {
                session_id = top.runOptions.getSessionId();
              } else {
                session_id = 'user';
              }

              ajax({
                type: "POST",
                url: '/suites/' + session_id + '/finish',
                data: {"text": error_text}
              });
            });
          })(jQuery);
        </script>
        <link rel="stylesheet" href="/core/screw.css" />
        HTML
        spec_files.each do |file|
          html << %{<script type="text/javascript" src="#{file.relative_path}"></script>\n}
        end

        html << <<-HTML
        </head>
        <body>
        <div id="screw_unit_content"></div>
        </body>
        </html>
        HTML
        connection.send_head
        connection.send_body(html.gsub(/^        /, ""))
      end
    end
  end
end
