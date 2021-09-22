# Run `rake calendly.gemspec` to update the gemspec.
#
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative "lib/calendly/version"

Gem::Specification.new do |spec|
  spec.name = "calendly"
  spec.version = Calendly::VERSION
  spec.authors = ["araluce"]
  spec.email = ["araluce11@gmail.com"]

  spec.summary = "Ruby bindings for Calendly API."
  spec.description = "Ruby bindings for Calendly API. Calendly APIs can be found here: https://calendly.stoplight.io/docs/api-docs/"
  spec.homepage = "https://github.com/araluce/calendly.rb"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")
  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 1.7"
  spec.add_dependency "faraday_middleware", "~> 1.1"
end
