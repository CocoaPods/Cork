# encoding: UTF-8
require File.expand_path('../lib/cork/gem_version', __FILE__)

Gem::Specification.new do |s|
  s.name     = "cork"
  s.version  = Cork::VERSION
  s.license  = "MIT"
  s.email    = ["k.isabel.sandoval@gmail.com"]
  s.homepage = "https://github.com/CocoaPods/Cork"
  s.authors  = ["Karla Sandoval"]
  s.summary  = "A delightful CLI UI module."

  s.files = Dir["lib/**/*.rb"] + %w{ README.md LICENSE CHANGELOG.md }

  s.require_paths = %w{ lib }

  s.add_runtime_dependency     'colored2',   '~> 3.1'

  s.add_development_dependency 'bundler',   '~> 1.3'
  s.add_development_dependency 'rake',      '>= 10.0'
  s.add_development_dependency 'bacon',     '~> 1.1'

  ## Make sure you can build the gem on older versions of RubyGems too:
  s.rubygems_version = "1.6.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>= 2.0.0'
  s.specification_version = 3 if s.respond_to? :specification_version
end
