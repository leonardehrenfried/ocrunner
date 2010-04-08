# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ocrunner}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jim Benton"]
  s.date = %q{2010-04-07}
  s.default_executable = %q{ocrunner}
  s.description = %q{Provides pretty console output}
  s.email = %q{jim@autonomousmachine.com}
  s.executables = ["ocrunner"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/ocrunner",
     "lib/ocrunner.rb",
     "lib/ocrunner/console.rb",
     "lib/ocrunner/test_case.rb",
     "lib/ocrunner/test_runner.rb",
     "test/helper.rb",
     "test/test_ocrunner.rb"
  ]
  s.homepage = %q{http://github.com/jim/ocrunner}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A small Ruby wrapper for running OCUnit tests with xcodebuilder}
  s.test_files = [
    "test/helper.rb",
     "test/test_ocrunner.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<trollop>, [">= 0"])
    else
      s.add_dependency(%q<trollop>, [">= 0"])
    end
  else
    s.add_dependency(%q<trollop>, [">= 0"])
  end
end

