# -*- encoding: utf-8 -*-
# stub: shareable 1.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "shareable"
  s.version = "1.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Hermango"]
  s.date = "2014-07-27"
  s.description = "Add social sharing functionality to your Rails app with one method call. Shareable allows you the choice of displaying javascript buttons or static links. Configuration options for each social site are ready-to-use and entirely customizable. Please see readme for more details."
  s.homepage = "http://github.com/hermango/shareable"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Simple and unobtrusive gem for adding social links to your Rails app. Rails 3 and 4 supported."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<actionpack>, [">= 3.0.0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<actionpack>, [">= 3.0.0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<actionpack>, [">= 3.0.0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
  end
end
