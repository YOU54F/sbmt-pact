# frozen_string_literal: true

module Sbmt
  module Pact
    module Matchers
      module V4
        class EachValue < Sbmt::Pact::Matchers::Base
          def initialize(value_matchers, template)
            # raise MatcherInitializationError, "#{self.class}: #{template} should be a Hash" unless template.is_a?(Hash)
            raise MatcherInitializationError, "#{self.class}: #{value_matchers} should be an Array" unless value_matchers.is_a?(Array)
            raise MatcherInitializationError, "#{self.class}: #{value_matchers} should be instances of Sbmt::Pact::Matchers::Base" unless value_matchers.all?(Sbmt::Pact::Matchers::Base)
            raise MatcherInitializationError, "#{self.class}: #{value_matchers} size should be greater than 0" unless value_matchers.size > 0

            super(spec_version: Sbmt::Pact::Matchers::PACT_SPEC_V4, kind: "each-value", template: template, opts: {rules: value_matchers})
          end

          def as_plugin
            if @template.is_a?(Hash)
              return {
                "pact:match" => "eachValue(matching($'SAMPLE'))",
                "SAMPLE" => serialize!(@template.deep_dup, :plugin)
              }
            end

            @opts[:rules].map do |matcher|
              "eachValue(#{matcher.as_plugin})"
            end.join(", ")
          end
        end
      end
    end
  end
end
