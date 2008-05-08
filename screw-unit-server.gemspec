Gem::Specification.new do |s|
  s.name = "screw_unit"
  s.version = "0.1.0"
  s.date = "2008-05-08"
  s.summary = "The ScrewUnit client library (http://github.com/nkallen/screw-unit) plus a convenient ruby server."
  s.email = "brian.takita@gmail.com"
  s.homepage = "http://github.com/btakita/screw-unit-server"
  s.description = "The Screw Unit server conveniently serves your Screw Unit specs and implementations javascript files and css stylesheets. The Screw Unit core is located at http://github.com/nkallen/screw-unit/tree."
  s.has_rdoc = true
  s.authors = ["Brian Takita"]
  s.files = Dir["[A-Z]*"] +
    Dir["*.rb"] +
    Dir["lib/**/*.rb"] +
    Dir["core/**"] +
    Dir["bin/**"] +
    Dir["vendor/**"] +
    Dir["spec/**"]
  p s.files
  s.test_files = Dir['spec/**/*.rb']
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README", "CHANGES"]
end