# -*- encoding: utf-8 -*-
# stub: jekyll-minimagick 0.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-minimagick".freeze
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Roger L\u00F3pez".freeze]
  s.date = "2016-11-27"
  s.description = "Use MiniMagick to crop and resize images in your Jekyll project.".freeze
  s.email = ["roger@zroger.com".freeze]
  s.homepage = "http://github.com/zroger/jekyll-minimagick".freeze
  s.rubygems_version = "3.0.6".freeze
  s.summary = "MiniMagick integration for Jekyll".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jekyll>.freeze, [">= 0.10.0"])
      s.add_runtime_dependency(%q<mini_magick>.freeze, [">= 3.3"])
    else
      s.add_dependency(%q<jekyll>.freeze, [">= 0.10.0"])
      s.add_dependency(%q<mini_magick>.freeze, [">= 3.3"])
    end
  else
    s.add_dependency(%q<jekyll>.freeze, [">= 0.10.0"])
    s.add_dependency(%q<mini_magick>.freeze, [">= 3.3"])
  end
end
