# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_bioc/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_bioc"
  spec.version       = SimpleBioC::VERSION
  spec.authors       = ["Dongseop Kwon"]
  spec.email         = ["dongseop@gmail.com"]
  spec.description   = "Simple BioC parser/builder for ruby. BioC is a 'A Minimalist Approach to Interoperability for Biomedical Text Processing' (http://www.ncbi.nlm.nih.gov/CBBresearch/Dogan/BioC/BioCHome.html)"
  spec.summary       = "Simple BioC parser/builder for ruby"
  spec.homepage      = "https://github.com/dongseop/simple_bioc"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("nokogiri",       [">= 1.3.2"])

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency("rspec-core", ["~> 2.2"])
  spec.add_development_dependency("test-xml", ["~> 0.1.6"])
end
