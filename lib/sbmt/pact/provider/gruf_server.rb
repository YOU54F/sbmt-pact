# frozen_string_literal: true

module Sbmt
  module Pact
    module Provider
      # inspired by Gruf::Cli::Executor
      class GrufServer
        def initialize(options = {})
          @options = options

          setup!

          @server_pid = nil

          @services = @options[:services].is_a?(Array) ? @options[:services] : []
          @logger = @options[:logger] || Gruf.logger || ::Logger.new($stdout)
        end

        def start
          raise "server already running, stop server before starting new one" if @thread

          @logger.info("[gruf] starting standalone server with options: #{@options}")

          @server = Gruf::Server.new(Gruf.server_options)
          @thread = Thread.new do
            Rails.logger.debug "starting grpc server"
            @server.start!
          end
          @server.server.wait_till_running(10)

          @logger.info("[gruf] standalone server started")
        end

        def stop
          @logger.info("[gruf] stopping standalone server")

          @server.server.stop
          @thread&.join

          @logger.info("[gruf] standalone server stopped")
        end

        ##
        # Run the server
        #
        def run
          start

          yield
        rescue => e
          @logger.fatal("FATAL ERROR: #{e.message} #{e.backtrace.join("\n")}")
          raise
        ensure
          stop
        end

        private

        def setup!
          Gruf.server_binding_url = @options[:host] if @options[:host]
          if @options[:suppress_default_interceptors]
            Gruf.interceptors.remove(Gruf::Interceptors::ActiveRecord::ConnectionReset)
            Gruf.interceptors.remove(Gruf::Interceptors::Instrumentation::OutputMetadataTimer)
          end
          Gruf.backtrace_on_error = true if @options[:backtrace_on_error]
          Gruf.health_check_enabled = true if @options[:health_check]
        end
      end
    end
  end
end
