# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{screw-unit-server}
  s.version = "0.5.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pivotal Labs", "Brian Takita"]
  s.date = %q{2009-06-08}
  s.description = %q{The Screw Unit server conveniently serves your Screw Unit specs and javascript files and css stylesheets.}
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
    "lib/screw_unit/server.rb",
    "spec/functional_suite.rb",
    "spec/spec_suite.rb",
    "spec/unit_suite.rb",
    "vendor/js-test-core/CHANGES",
    "vendor/js-test-core/README",
    "vendor/js-test-core/Rakefile",
    "vendor/js-test-core/lib/js_test_core.rb",
    "vendor/js-test-core/lib/js_test_core/app.rb",
    "vendor/js-test-core/lib/js_test_core/client.rb",
    "vendor/js-test-core/lib/js_test_core/configuration.rb",
    "vendor/js-test-core/lib/js_test_core/extensions.rb",
    "vendor/js-test-core/lib/js_test_core/extensions/selenium/client/driver.rb",
    "vendor/js-test-core/lib/js_test_core/extensions/time.rb",
    "vendor/js-test-core/lib/js_test_core/models.rb",
    "vendor/js-test-core/lib/js_test_core/models/selenium_session.rb",
    "vendor/js-test-core/lib/js_test_core/representations.rb",
    "vendor/js-test-core/lib/js_test_core/representations/dir.html.rb",
    "vendor/js-test-core/lib/js_test_core/representations/not_found.html.rb",
    "vendor/js-test-core/lib/js_test_core/representations/page.html.rb",
    "vendor/js-test-core/lib/js_test_core/representations/spec.html.rb",
    "vendor/js-test-core/lib/js_test_core/resources.rb",
    "vendor/js-test-core/lib/js_test_core/resources/core_file.rb",
    "vendor/js-test-core/lib/js_test_core/resources/file.rb",
    "vendor/js-test-core/lib/js_test_core/resources/implementations_deprecation.rb",
    "vendor/js-test-core/lib/js_test_core/resources/not_found.rb",
    "vendor/js-test-core/lib/js_test_core/resources/resource.rb",
    "vendor/js-test-core/lib/js_test_core/resources/selenium_session.rb",
    "vendor/js-test-core/lib/js_test_core/resources/spec_file.rb",
    "vendor/js-test-core/lib/js_test_core/resources/web_root.rb",
    "vendor/js-test-core/lib/js_test_core/selenium_server_configuration.rb",
    "vendor/js-test-core/spec/example_core/JsTestCore.css",
    "vendor/js-test-core/spec/example_core/JsTestCore.js",
    "vendor/js-test-core/spec/example_core/subdir/SubDirFile.js",
    "vendor/js-test-core/spec/example_public/favicon.ico",
    "vendor/js-test-core/spec/example_public/javascripts/foo.js",
    "vendor/js-test-core/spec/example_public/javascripts/large_file.js",
    "vendor/js-test-core/spec/example_public/javascripts/subdir/bar.js",
    "vendor/js-test-core/spec/example_public/robots.txt",
    "vendor/js-test-core/spec/example_public/stylesheets/example.css",
    "vendor/js-test-core/spec/example_specs/custom_dir_and_suite/passing_spec.js",
    "vendor/js-test-core/spec/example_specs/custom_suite.html",
    "vendor/js-test-core/spec/example_specs/failing_spec.js",
    "vendor/js-test-core/spec/example_specs/foo/failing_spec.js",
    "vendor/js-test-core/spec/example_specs/foo/passing_spec.js",
    "vendor/js-test-core/spec/spec_helpers/be_http.rb",
    "vendor/js-test-core/spec/spec_helpers/example_group.rb",
    "vendor/js-test-core/spec/spec_helpers/fake_selenium_driver.rb",
    "vendor/js-test-core/spec/spec_helpers/show_test_exceptions.rb",
    "vendor/js-test-core/spec/spec_suite.rb",
    "vendor/js-test-core/spec/specs/failing_spec.js",
    "vendor/js-test-core/spec/unit/js_test_core/client_spec.rb",
    "vendor/js-test-core/spec/unit/js_test_core/configuration_spec.rb",
    "vendor/js-test-core/spec/unit/js_test_core/models/selenium_session_spec.rb",
    "vendor/js-test-core/spec/unit/js_test_core/resources/core_file_spec.rb",
    "vendor/js-test-core/spec/unit/js_test_core/resources/file_spec.rb",
    "vendor/js-test-core/spec/unit/js_test_core/resources/implementations_deprecation_spec.rb",
    "vendor/js-test-core/spec/unit/js_test_core/resources/not_found_spec.rb",
    "vendor/js-test-core/spec/unit/js_test_core/resources/selenium_session_spec.rb",
    "vendor/js-test-core/spec/unit/js_test_core/resources/spec_file_spec.rb",
    "vendor/js-test-core/spec/unit/js_test_core/resources/web_root_spec.rb",
    "vendor/js-test-core/spec/unit/js_test_core/selenium_server_configuration_spec.rb",
    "vendor/js-test-core/spec/unit/unit_spec_helper.rb",
    "vendor/js-test-core/spec/unit_suite.rb",
    "vendor/js-test-core/vendor/lucky-luciano/README.markdown",
    "vendor/js-test-core/vendor/lucky-luciano/lib/lucky_luciano.rb",
    "vendor/js-test-core/vendor/lucky-luciano/lib/lucky_luciano/resource.rb",
    "vendor/js-test-core/vendor/lucky-luciano/lib/lucky_luciano/rspec.rb",
    "vendor/js-test-core/vendor/lucky-luciano/lib/lucky_luciano/rspec/be_http.rb",
    "vendor/js-test-core/vendor/lucky-luciano/spec/lucky_luciano/resource_spec.rb",
    "vendor/js-test-core/vendor/lucky-luciano/spec/spec_helper.rb",
    "vendor/js-test-core/vendor/lucky-luciano/spec/spec_suite.rb"
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
    "spec/unit/js_test_core/specs/spec_file_spec.rb",
    "spec/unit/unit_spec_helper.rb",
    "spec/unit_suite.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thin>, [">= 1.2.1"])
      s.add_runtime_dependency(%q<erector>, [">= 0.6.6"])
      s.add_runtime_dependency(%q<selenium-client>, [">= 0"])
    else
      s.add_dependency(%q<thin>, [">= 1.2.1"])
      s.add_dependency(%q<erector>, [">= 0.6.6"])
      s.add_dependency(%q<selenium-client>, [">= 0"])
    end
  else
    s.add_dependency(%q<thin>, [">= 1.2.1"])
    s.add_dependency(%q<erector>, [">= 0.6.6"])
    s.add_dependency(%q<selenium-client>, [">= 0"])
  end
end
