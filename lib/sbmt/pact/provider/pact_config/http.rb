# frozen_string_literal: true

require_relative "base"

module Sbmt
  module Pact
    module Provider
      module PactConfig
        class Http < Base
          attr_reader :http_port
          attr_reader :app

          def initialize(provider_name:, opts: {})
            super

            @http_port = opts[:http_port] || 3000
            @app = opts[:app] || nil
          end

          def new_verifier
            HttpVerifier.new(self)
          end
        end
      end
    end
  end
end
