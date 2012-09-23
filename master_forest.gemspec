# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'master_forest/version'

Gem::Specification.new do |gem|
  gem.name          = "master_forest"
  gem.version       = MasterForest::VERSION
  gem.authors       = ["Joe Nelson"]
  gem.email         = ["cred+github@begriffs.com"]
  gem.description   = %q{Yeah, what the summary says}
  gem.summary       = %q{Combinatory logic parsing and reduction}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
end
