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

    def to_s
      @raw_message
    end
  end
end
