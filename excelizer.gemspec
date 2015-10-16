# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'excelizer/version'

Gem::Specification.new do |spec|
  spec.name          = "excelizer"
  spec.version       = Excelizer::VERSION
  spec.authors       = ["Arturo Puente"]
  spec.email         = ["arturopuentevc@gmail.com"]
  spec.description   = "An Excel helper for Rails project. It integrates with ActiveRecord models and other space magic."
  spec.summary       = "An Excel helper for Rails project"
  spec.homepage      = "https://github.com/arturopuente/excelizer"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "guard", "~> 2.13"
  spec.add_development_dependency "guard-rspec", "~> 4.6"
  spec.add_development_dependency "rspec-nc", "~> 0.2"
  spec.add_development_dependency "rspec-legacy_formatters", "~> 1.0"

  spec.add_dependency "spreadsheet", "~> 1.0"
end
