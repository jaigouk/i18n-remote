# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require_relative "lib/i18n/backend/remote/version"

Gem::Specification.new do |spec|
  spec.name = "i18n-remote"
  spec.version       = I18n::Backend::Remote::VERSION
  spec.authors       = ["Jaigouk Kim"]
  spec.email         = ["ping@jaigouk.kim"]

  spec.summary       = "i18n for remote file"
  spec.description   = "fetch remote file and translate. fall back to local file when it fails to fetch the file."
  spec.homepage      = "https://github.com/jaigouk/i18n-remote"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("faraday")
  spec.add_runtime_dependency("faraday-net_http_persistent")
  spec.add_runtime_dependency("i18n", "~> 1.10")
  spec.add_runtime_dependency("parallel")
  spec.add_runtime_dependency("psych")
  spec.add_development_dependency "bundler"
  spec.add_development_dependency("byebug")
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "test_declarative"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.metadata["rubygems_mfa_required"] = "true"
end
