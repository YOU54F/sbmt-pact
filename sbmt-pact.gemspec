# frozen_string_literal: true

require_relative "lib/sbmt/pact/version"

Gem::Specification.new do |spec|
  spec.name = "sbmt-pact"
  spec.version = Sbmt::Pact::VERSION
  spec.authors = ["Ruby Platform Team"]

  spec.summary = "Pact contract testing helpers"
  spec.description = spec.summary
  spec.homepage = "https://gitlab.sbmt.io/nstmrt/rubygems/sbmt-pact"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["allowed_push_host"] = "https://nexus.sbmt.io"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/-/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "false" # rubocop:disable Gemspec/RequireMFA

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

  spec.add_dependency "zeitwerk", "~> 2.3"
  spec.add_dependency "pact-ffi", "~> 0.0.3"
  spec.add_dependency "ffi", "~> 1.15"

  spec.add_development_dependency "appraisal", ">= 2.4"
  spec.add_development_dependency "bundler", ">= 2.3"
  spec.add_development_dependency "combustion", ">= 1.3"
  spec.add_development_dependency "rake", ">= 13.0"
  spec.add_development_dependency "sbmt-dev", ">= 0.1.0"
end