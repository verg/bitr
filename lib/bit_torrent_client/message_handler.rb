module BitTorrentClient
  class MessageHandler
    attr_reader :stream, :handshook
    alias :handshook? :handshook

    def initialize(opts={})
      @handshook = opts.fetch(:handshook) { false }
      @stream = ""
      @parsed_messages = []
    end

    def handle(data)
      @stream << data
      handle_handshake

      while full_message_available?
        parse
      end
      dequeue_messages
    end

    def parse
      message_string = @stream.slice!(0...full_length)
      @parsed_messages << Message.new(message_string)
    end

    def dequeue_messages
      parsed = @parsed_messages
      @parsed_messages = []
      parsed
    end

    def full_message_available?
      has_minimum_length? && full_length <= @stream.length
    end

    def full_length
      @stream[0..3].unpack("N").first + 4
    end

    def has_minimum_length?
      @stream.length > 3
    end

    def handle_handshake
      if !handshook? && @stream.length >= 68
        @stream.slice!(0..67)
        @handshook = true
      end
    end
  end
end
