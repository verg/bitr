require 'forwardable'

module BitTorrentClient
  class PieceCollection
    extend Forwardable
    def_delegators :@pieces, :each, :<<, :length, :size, :first, :last

    def initialize(pieces=[])
      @pieces = pieces
    end

    def find(index)
      index = convert_byte_to_int(index) if index.class == String
      @pieces.find { |piece| piece.index == index }
    end

    def convert_byte_to_int(data)
      data.unpack("N")[0]
    end

    def incomplete
      @pieces.select { |piece| !piece.complete? }
    end

    def complete
      @pieces.select { |piece| piece.complete? }
    end

    def download_complete?
      @pieces.none? { |piece| !piece.complete? }
    end
  end
end
