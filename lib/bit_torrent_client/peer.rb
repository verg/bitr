module BitTorrentClient
  class Peer
    attr_reader :ip, :port
    attr_accessor :choking, :interested
    alias_method :choking?, :choking
    alias_method :interested?, :interested

    def initialize(args)
      @ip = args.fetch(:ip)
      @port = args.fetch(:port)
      @choking = true
      @interested = false
      @available_pieces = []
    end

    def process_bitfield(bitfield)
      @available_pieces = unpack_bitfield(bitfield).map do |char|
        char == "1" ? true : false
      end
    end

    def has_piece?(index)
      @available_pieces[index]
    end

    def has_piece_at(index)
      index = index.unpack("N").first if index.class == String
      @available_pieces[index] = true
    end

    private
    def unpack_bitfield(bitfield)
      bitfield.unpack("B*").first.chars
    end
  end
end
