# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "factory_girl/upgrader/version"

Gem::Specification.new do |s|
  s.name        = "factory_girl_upgrader"
  s.version     = FactoryGirl::Upgrader::VERSION
  s.author      = "Ben Hughes"
  s.email       = "ben@railsgarden.com"
  s.homepage    = "http://github.com/rubiety/factory_girl_upgrader"
  s.summary     = "Converts factory_girl V1 DSL factories to factory_girl V2 DSL."
  s.description = "Uses ruby_parser and ruby_scribe to dynamically convert factory_girl factories in the V1 DSL into the V2 DSL."
  
  s.executables = ["factory_girl_upgrader"]
  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"
  
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
  
  s.add_dependency("thor", ["~> 0.13"])
  s.add_dependency("activesupport", ["~> 3.0"])
  s.add_dependency("i18n", ["~> 0.6.0"])
  s.add_dependency("factory_girl", ["~> 2.0"])
  s.add_dependency("ruby_parser", ["~> 2.3.1"])
  s.add_dependency("ruby_scribe", ["~> 0.1.4"])
  s.add_dependency("ruby_transform", ["~> 0.1.0"])
  s.add_development_dependency("rspec", ["~> 2.0"])
end
