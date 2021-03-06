module BitTorrentClient
  class Message
    def initialize(raw_message)
      @raw_message = raw_message
      @parsed = MessageParser.new(raw_message)
    end

    def type
      @parsed.type
    end

    def payload
      @parsed.payload
    end
    alias :bitfield :payload

    def block
      payload[8...@raw_message.length]
    end

    def to_s
      @raw_message
    end

    def piece_index
      @parsed.piece_index
    end

    def byte_offset
      @parsed.byte_offset
    end

  end
end
