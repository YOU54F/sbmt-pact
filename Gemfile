# frozen_string_literal: true

source ENV.fetch("RUBYGEMS_PUBLIC_SOURCE", "https://rubygems.org/")

gemspec
unless RUBY_PLATFORM =~ /win32/
  group :test do
    gem "sbmt-kafka_consumer", ">= 2.0.1"
    gem "sbmt-kafka_producer", ">= 1.0"
  end
end