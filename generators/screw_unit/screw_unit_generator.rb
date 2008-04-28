require 'rbconfig'

# This generator bootstraps a Rails project for use with ScrewUnit
class ScrewUnitGenerator < Rails::Generator::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  def manifest
    record do |m|
      script_options     = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }

      m.directory 'spec'
      m.directory 'spec/javascripts'
      m.template  'spec_helper.js',                 'spec/javascripts/spec_helper.js'
      m.file      'script/screw_unit_server',          'script/screw_unit_server', script_options
      m.file      'script/screw_unit',                 'script/screw_unit',        script_options
    end
  end

protected

  def banner
    "Usage: #{$0} screw_unit"
  end

end
