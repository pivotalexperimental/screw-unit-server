module JsTestCore
  module Representations
    module Suites
      class ScrewUnit < JsTestCore::Representations::Suite
        class << self
          def jquery_js_file
            @jquery_js_file ||= "/core/jquery-1.3.2.js"
          end
          attr_writer :jquery_js_file
        end

        attr_reader :spec_files
        needs :spec_files
        def title_text
          "Screw Unit suite"
        end

        def head_content
          core_js_files
          script(raw(<<-JS), :type => "text/javascript")
            (function($) {
              var jsTestServerStatus = {"runner_state": "#{Client::RUNNING_RUNNER_STATE}", "console": ""};

              JsTestServer.status = function() {
                return JsTestServer.JSON.stringify(jsTestServerStatus);
              };

              $(Screw).bind('after', function() {
                var error_text = $(".error").map(function(i, error_element) {
                  var element = $(error_element);

                  var parent_descriptions = element.parents("li.describe");
                  var parent_description_text = [];

                  for(var i=parent_descriptions.length-1; i >= 0; i--) {
                    parent_description_text.push($(parent_descriptions[i]).find("h1").text());
                  }

                  var it_text = element.parents("li.it").find("h2").text();

                  return parent_description_text.join(" ") + " " + it_text + ": " + element.text();
                }).get().join("\\n");

                jsTestServerStatus["console"] = error_text;
                if(error_text) {
                  jsTestServerStatus["runner_state"] = "#{Client::FAILED_RUNNER_STATE}";
                } else {
                  jsTestServerStatus["runner_state"] = "#{Client::PASSED_RUNNER_STATE}";
                }
              });
            })(jQuery);
          JS
          project_js_files
          link :rel => "stylesheet", :href => "/core/screw.css"
          project_css_files

          spec_script_elements
        end

        def core_js_files
          script :src => jquery_js_file
          script :src => "/js_test_server.js"
          script :src => "/core/jquery.fn.js"
          script :src => "/core/jquery.print.js"
          script :src => "/core/screw.builder.js"
          script :src => "/core/screw.matchers.js"
          script :src => "/core/screw.events.js"
          script :src => "/core/screw.behaviors.js"
        end

        def jquery_js_file
          self.class.jquery_js_file
        end

        def body_content
          div :id => "screw_unit_content"
        end
      end
    end
  end
end