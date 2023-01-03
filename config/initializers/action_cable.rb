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
