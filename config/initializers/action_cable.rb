# frozen_string_literal: true

ActionCable.server.config.logger = Logger.new(nil)

module ActionCable
  module Connection
    class ClientSocket
      alias_method :old_initialize, :initialize
      def initialize(env, event_target, event_loop, protocols)
        old_initialize(env, event_target, event_loop, protocols)
        @driver.add_extension(
          PermessageDeflate.configure(
            level: Zlib::BEST_COMPRESSION,
            max_window_bits: 13
          )
        )
      end
    end
  end
end

# Restart Action Cable server on Redis connection failures.
# See: https://github.com/rails/rails/pull/45478
require 'action_cable/subscription_adapter/redis'

module ActionCableRedisListenerPatch
  private

  def ensure_listener_running
    @thread ||= Thread.new do
      Thread.current.abort_on_exception = true
      conn = @adapter.redis_connection_for_subscriptions
      listen conn
    rescue ::Redis::BaseConnectionError
      @thread = @raw_client = nil
      ::ActionCable.server.restart
    end
  end
end

ActionCable::SubscriptionAdapter::Redis::Listener.prepend(ActionCableRedisListenerPatch)

