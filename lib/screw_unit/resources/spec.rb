module ScrewUnit
  module Resources
    module Spec
      def get
        html = <<-HTML
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
        <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
        <title>ScrewUnit results</title>
        <script src="/core/jquery-1.2.3.js"></script>
        <script src="/core/jquery.fn.js"></script>
        <script src="/core/jquery.print.js"></script>
        <script src="/core/screw.builder.js"></script>
        <script src="/core/screw.matchers.js"></script>
        <script src="/core/screw.events.js"></script>
        <script src="/core/screw.behaviors.js"></script>
        <script src="/core/screw.assets.js"></script>
        <script src="/core/screw.server.js"></script>
        <link rel="stylesheet" href="/core/screw.css">
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
