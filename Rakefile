require "rake"
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

desc "Runs the Rspec suite"
task(:default) do
  run_suite
end

desc "Runs the Rspec suite"
task(:spec) do
  run_suite
end

desc "Copies the trunk to a tag with the name of the current release"
task(:tag_release) do
  tag_release
end

def run_suite
  dir = File.dirname(__FILE__)
  system("ruby #{dir}/spec/spec_suite.rb") || raise("Example Suite failed")
end

PKG_NAME = "screw_unit"
PKG_VERSION = "0.2.0"
PKG_FILES = FileList[
  '[A-Z]*',
  '*.rb',
  'lib/**/*.rb',
  'core/**',
  'bin/**',
  'spec/**/*.rb'
]

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = "The ScrewUnit client library (http://github.com/nkallen/screw-unit) plus a convenient ruby server."
  s.test_files = "spec/spec_suite.rb"
  s.description = s.summary

  s.files = PKG_FILES.to_a
  s.require_path = 'lib'

  s.has_rdoc = true
  s.extra_rdoc_files = [ "README", "CHANGES" ]
  s.rdoc_options = ["--main", "README", "--inline-source", "--line-numbers"]

  s.test_files = Dir.glob('spec/*_spec.rb')
  s.require_path = 'lib'
  s.author = "Brian Takita"
  s.email = "brian@pivotallabs.com"
  s.homepage = "http://pivotallabs.com"
  s.rubyforge_project = "pivotalrb"
  s.add_dependency('Selenium')
  s.add_dependency('thin', '>=0.8.0')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

def tag_release
  system("git tag #{dashed_version} -m 'Version #{PKG_VERSION}'")
end
