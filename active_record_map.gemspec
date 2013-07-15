# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record_map/version'

Gem::Specification.new do |spec|
  spec.name          = "active_record_map"
  spec.version       = ActiveRecordMap::VERSION
  spec.authors       = ["Jeremiah Heller"]
  spec.email         = ["ib.jeremiah@gmail.com"]
  spec.description   = %q{A small gem for simplifying access to json columns via ActiveRecord and Map.}
  spec.summary       = %q{Wrap PostgreSQL json ActiveRecord attributes with Map, which provides ordered and indifferent hash access (e.g. `ar_record.json_attr['foo'][:bar]`) as well as access via instance methods (e.g. `ar_record.json_attr.foo.bar`).}
  spec.homepage      = "https://github.com/inertialbit/active_record_map"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{_spec.rb\Z})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"

  spec.add_dependency "activerecord", "~> 4.0"
  spec.add_dependency "map"
  spec.add_dependency "json"
  spec.add_dependency "pg"
end
