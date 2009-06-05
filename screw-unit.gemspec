# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{screw-unit}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pivotal Labs", "Brian Takita"]
  s.date = %q{2009-06-04}
  s.description = %q{The Screw Unit server conveniently serves your Screw Unit specs and implementations javascript files and css stylesheets.}
  s.email = %q{pivotallabsopensource@googlegroups.com}
  s.executables = ["screw_unit", "screw_unit_server"]
  s.extra_rdoc_files = [
    "CHANGES",
     "README.markdown"
  ]
  s.files = [
    "CHANGES",
     "README.markdown",
     "Rakefile",
     "VERSION.yml",
     "bin/screw_unit",
     "bin/screw_unit_server",
     "core/CHANGES",
     "core/EXAMPLE.html",
     "core/LICENSE",
     "core/README.markdown",
     "core/example/models/cat.js",
     "core/example/models/man.js",
     "core/example/spec/matchers/have.js",
     "core/example/spec/models/cat_spec.js",
     "core/example/spec/models/man_spec.js",
     "core/example/spec/spec_helper.js",
     "core/example/spec/suite.html",
     "core/lib/jquery-1.3.2.js",
     "core/lib/jquery.fn.js",
     "core/lib/jquery.print.js",
     "core/lib/screw.behaviors.js",
     "core/lib/screw.builder.js",
     "core/lib/screw.css",
     "core/lib/screw.events.js",
     "core/lib/screw.matchers.js",
     "core/spec/behaviors_spec.js",
     "core/spec/matchers_spec.js",
     "core/spec/print_spec.js",
     "core/spec/spec_helper.js",
     "core/spec/suite.html",
     "core/spec/with_screw_context_spec.js",
     "init.rb",
     "lib/screw_unit.rb",
     "lib/screw_unit/representations.rb",
     "lib/screw_unit/representations/spec.html.rb",
     "spec/functional_suite.rb",
     "spec/spec_suite.rb",
     "spec/unit_suite.rb",
     "vendor/js-test-core/CHANGES",
     "vendor/js-test-core/README",
     "vendor/js-test-core/Rakefile",
     "vendor/js-test-core/lib/js_test_core.rb",
     "vendor/js-test-core/lib/js_test_core/client.rb",
     "vendor/js-test-core/lib/js_test_core/extensions.rb",
     "vendor/js-test-core/lib/js_test_core/extensions/time.rb",
     "vendor/js-test-core/lib/js_test_core/rack.rb",
     "vendor/js-test-core/lib/js_test_core/rack/commonlogger.rb",
     "vendor/js-test-core/lib/js_test_core/rails_server.rb",
     "vendor/js-test-core/lib/js_test_core/representations.rb",
     "vendor/js-test-core/lib/js_test_core/representations/spec.html.rb",
     "vendor/js-test-core/lib/js_test_core/resources.rb",
     "vendor/js-test-core/lib/js_test_core/resources/dir.rb",
     "vendor/js-test-core/lib/js_test_core/resources/file.rb",
     "vendor/js-test-core/lib/js_test_core/resources/runner.rb",
     "vendor/js-test-core/lib/js_test_core/resources/session.rb",
     "vendor/js-test-core/lib/js_test_core/resources/session_finish.rb",
     "vendor/js-test-core/lib/js_test_core/resources/specs/spec.rb",
     "vendor/js-test-core/lib/js_test_core/resources/specs/spec_dir.rb",
     "vendor/js-test-core/lib/js_test_core/resources/specs/spec_file.rb",
     "vendor/js-test-core/lib/js_test_core/resources/web_root.rb",
     "vendor/js-test-core/lib/js_test_core/selenium.rb",
     "vendor/js-test-core/lib/js_test_core/selenium/client/driver.rb",
     "vendor/js-test-core/lib/js_test_core/selenium_server_configuration.rb",
     "vendor/js-test-core/lib/js_test_core/server.rb",
     "vendor/js-test-core/lib/js_test_core/thin.rb",
     "vendor/js-test-core/lib/js_test_core/thin/backends/js_test_core_server.rb",
     "vendor/js-test-core/lib/js_test_core/thin/js_test_core_connection.rb",
     "vendor/js-test-core/spec/example_core/JsTestCore.css",
     "vendor/js-test-core/spec/example_core/JsTestCore.js",
     "vendor/js-test-core/spec/example_public/favicon.ico",
     "vendor/js-test-core/spec/example_public/javascripts/foo.js",
     "vendor/js-test-core/spec/example_public/javascripts/large_file.js",
     "vendor/js-test-core/spec/example_public/javascripts/subdir/bar.js",
     "vendor/js-test-core/spec/example_public/robots.txt",
     "vendor/js-test-core/spec/example_public/stylesheets/example.css",
     "vendor/js-test-core/spec/example_specs/custom_dir_and_suite.html",
     "vendor/js-test-core/spec/example_specs/custom_dir_and_suite/passing_spec.js",
     "vendor/js-test-core/spec/example_specs/custom_suite.html",
     "vendor/js-test-core/spec/example_specs/failing_spec.js",
     "vendor/js-test-core/spec/example_specs/foo/failing_spec.js",
     "vendor/js-test-core/spec/example_specs/foo/passing_spec.js",
     "vendor/js-test-core/spec/spec_suite.rb",
     "vendor/js-test-core/spec/specs/failing_spec.js",
     "vendor/js-test-core/spec/unit/js_test_core/client_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/rails_server_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/resources/dir_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/resources/file_not_found_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/resources/file_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/resources/runners/runner_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/resources/session_finish_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/resources/session_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/resources/specs/spec_dir_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/resources/specs/spec_file_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/resources/web_root_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/selenium_server_configuration_spec.rb",
     "vendor/js-test-core/spec/unit/js_test_core/server_spec.rb",
     "vendor/js-test-core/spec/unit/thin/js_test_core_connection_spec.rb",
     "vendor/js-test-core/spec/unit/unit_spec_helper.rb",
     "vendor/js-test-core/spec/unit_suite.rb",
     "vendor/js-test-core/vendor/thin-rest/CHANGES",
     "vendor/js-test-core/vendor/thin-rest/README",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/connection.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/extensions.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/extensions/object.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/representations.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/representations/internal_error.html.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/representations/page.html.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/representations/resource_not_found.html.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/resources.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/resources/internal_error.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/resources/resource.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/resources/resource_not_found.rb",
     "vendor/js-test-core/vendor/thin-rest/lib/thin_rest/routing_error.rb",
     "vendor/js-test-core/vendor/thin-rest/spec/spec_suite.rb",
     "vendor/js-test-core/vendor/thin-rest/spec/thin_rest/connection_spec.rb",
     "vendor/js-test-core/vendor/thin-rest/spec/thin_rest/resources/resource_not_found_spec.rb",
     "vendor/js-test-core/vendor/thin-rest/spec/thin_rest/resources/resource_spec.rb",
     "vendor/js-test-core/vendor/thin-rest/spec/thin_rest/resources/root_spec.rb",
     "vendor/js-test-core/vendor/thin-rest/spec/thin_rest_spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/pivotal/screw-unit-server}
  s.rdoc_options = ["--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Server and helpers for your Screw Unit tests.}
  s.test_files = [
    "spec/functional/functional_spec.rb",
     "spec/functional/functional_spec_helper.rb",
     "spec/functional/functional_spec_server_starter.rb",
     "spec/functional_suite.rb",
     "spec/spec_suite.rb",
     "spec/unit/js_test_core/specs/spec_dir_spec.rb",
     "spec/unit/js_test_core/specs/spec_file_spec.rb",
     "spec/unit/unit_spec_helper.rb",
     "spec/unit_suite.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
