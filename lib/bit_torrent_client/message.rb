module BitTorrentClient
  class Message
    def initialize(string)
      @parsed = MessageParser.new(string)
    end

    def type
      @parsed.type
    end

    def payload
      @parsed.payload
    end
  end
end
