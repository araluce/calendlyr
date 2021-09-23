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
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "webmock", "~> 3.14.0"
  spec.add_development_dependency "codecov"
  spec.add_development_dependency "simplecov"
end
