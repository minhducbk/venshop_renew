# -*- encoding: utf-8 -*-
# stub: vacuum 1.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "vacuum"
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Hakan Ensari"]
  s.date = "2015-10-20"
  s.description = "A wrapper to the Amazon Product Advertising API"
  s.email = ["me@hakanensari.com"]
  s.homepage = "https://github.com/hakanensari/vacuum"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9")
  s.rubygems_version = "2.5.1"
  s.summary = "Amazon Product Advertising in Ruby"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jeff>, ["~> 1.0"])
      s.add_runtime_dependency(%q<multi_xml>, ["~> 0.5.0"])
      s.add_development_dependency(%q<minitest>, ["~> 5.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, [">= 0"])
      s.add_development_dependency(%q<vcr>, [">= 0"])
    else
      s.add_dependency(%q<jeff>, ["~> 1.0"])
      s.add_dependency(%q<multi_xml>, ["~> 0.5.0"])
      s.add_dependency(%q<minitest>, ["~> 5.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<appraisal>, [">= 0"])
      s.add_dependency(%q<vcr>, [">= 0"])
    end
  else
    s.add_dependency(%q<jeff>, ["~> 1.0"])
    s.add_dependency(%q<multi_xml>, ["~> 0.5.0"])
    s.add_dependency(%q<minitest>, ["~> 5.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<appraisal>, [">= 0"])
    s.add_dependency(%q<vcr>, [">= 0"])
  end
end
