# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ciseaux_csv/version'

Gem::Specification.new do |spec|
  spec.name          = "ciseaux_csv"
  spec.version       = CiseauxCsv::VERSION
  spec.authors       = ["Tricote"]
  spec.email         = ["thibaut.decaudain@gmail.com"]

  spec.summary       = "Tools for working with CSOV CSV files (Comma Separated Object Value)"
  spec.description   = "Tools for working with CSOV CSV files (Comma Separated Object Value)"
  spec.homepage      = "https://github.com/Tricote/ciseaux_csv"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]
  spec.test_files    = Dir["test/**/*.rb"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "yard"
end
