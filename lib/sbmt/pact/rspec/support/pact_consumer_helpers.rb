# frozen_string_literal: true

require_relative "pact_message_helpers"

module SbmtPactConsumerDsl
  include Sbmt::Pact::Matchers

  module ClassMethods
    def has_http_pact_between(consumer, provider, opts: {})
      _has_pact_between(:http, consumer, provider, opts: opts)
    end

    def has_grpc_pact_between(consumer, provider, opts: {})
      _has_pact_between(:grpc, consumer, provider, opts: opts)
    end

    def has_message_pact_between(consumer, provider, opts: {})
      _has_pact_between(:message, consumer, provider, opts: opts)
    end

    def _has_pact_between(transport_type, consumer, provider, opts: {})
      raise "has_#{transport_type}_pact_between is designed to be used with RSpec 3+" unless defined?(::RSpec)
      raise "has_#{transport_type}_pact_between has to be declared at the top level of a suite" unless top_level?
      raise "has_*_pact_between cannot be declared more than once per suite" if defined?(@_pact_config)

      # rubocop:disable RSpec/BeforeAfterAll
      before(:context) do
        @_pact_config = Sbmt::Pact::Consumer::PactConfig.new(transport_type, consumer_name: consumer, provider_name: provider, opts: opts)
      end
      # rubocop:enable RSpec/BeforeAfterAll
    end
  end

  def new_interaction(description = nil)
    pact_config.new_interaction(description)
  end

  def pact_config
    instance_variable_get(:@_pact_config)
  end

  def execute_http_pact
    raise InteractionBuilderError.new("interaction is designed to be used one-time only") if defined?(@used)
    mock_server = Sbmt::Pact::Consumer::MockServer.create_for_http!(
      pact: pact_config.pact_handle, host: pact_config.mock_host, port: pact_config.mock_port
    )

    yield(mock_server)

    if mock_server.matched?
      mock_server.write_pacts!(pact_config.pact_dir)
    else
      msg = mismatches_error_msg(mock_server)
      raise InteractionMismatchesError.new(msg)
    end
  ensure
    @used = true
    mock_server&.cleanup
  end
end

RSpec.configure do |config|
  config.include SbmtPactConsumerDsl, pact_entity: :consumer
  config.extend SbmtPactConsumerDsl::ClassMethods, pact_entity: :consumer
end
