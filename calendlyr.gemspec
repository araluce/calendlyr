require "./lib/calendlyr/version"

Gem::Specification.new do |spec|
  spec.name = "calendlyr"
  spec.version = Calendlyr::VERSION
  spec.authors = ["araluce"]
  spec.email = ["araluce11@gmail.com"]

  spec.summary = "Ruby bindings for Calendly API."
  spec.description = "Ruby bindings for Calendly API. Calendly APIs can be found here: https://calendly.stoplight.io/docs/api-docs/"
  spec.homepage = "https://github.com/araluce/calendlyr"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")
  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "minitest", "~> 5.25"
  spec.add_development_dependency "standard", "~> 1.40"
  spec.add_development_dependency "webmock", "~> 3.23"
  spec.add_development_dependency "codecov", "~> 0.6"
  spec.add_development_dependency "simplecov", "~> 0.21"
end
