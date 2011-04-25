
Gem::Specification.new do |s|
  s.name = %q{configy}
  s.version = "1.0.1"

  s.required_rubygems_version = ">= 1.3.6"
  s.authors = ["Gabe Varela", "Ben Marini"]
  s.date = %q{2011-04-21}
  s.email = %q{gvarela@gmail.com}
  s.summary = %q{Simple yaml driven configuration gem}
  s.homepage = %q{http://github.com/gvarela/configy}


  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
end

