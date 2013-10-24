module BitTorrentClient
  class MessageParser
    attr_reader :length, :type

    MESSAGE_TYPES  = {
      0 => :choke,
      1 => :unchoke,
      2 => :interested,
      3 => :not_interested,
      4 => :have,
      5 => :bitfield,
      6 => :request,
      7 => :piece,
      8 => :cancel,
      9 => :port
    }

    def initialize(message)
      @message = message
      @length = @message[0..3].unpack("N").first
    end

    def type
      return :keep_alive if @length == 0

      id = @message[4].unpack("C").first
      MESSAGE_TYPES.fetch(id)
    end

    def payload
      @message[5..-1] || ''
    end

    def piece_index
      case type
      when :have, :request, :piece, :cancel
        @message[5..8]
      else
        ""
      end
    end
  end
end
