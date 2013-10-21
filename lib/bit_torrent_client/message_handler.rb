module BitTorrent
  class MessageHandler
    attr_reader :stream, :handshook
    alias :handshook? :handshook

    def initialize(stream="")
      @handshook = false
      @stream = stream
      @parsed_messages = []
    end

    def parse
      handle_handshake
      if full_message_available?
        message_string = @stream.slice!(0...full_length)
        @parsed_messages << Message.new(message_string)
      end
      if full_message_available?
        parse
      else
        dequeue_messages
      end
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
      unless @handshook
        @stream.slice!(0..67)
        @handshook = true
      end
    end
  end
end
