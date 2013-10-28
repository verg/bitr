require 'forwardable'

module BitTorrentClient
  class PieceCollection
    extend Forwardable
    def_delegators :@pieces, :each, :<<, :length, :size

    def initialize(pieces=[])
      @pieces = pieces
    end

    def find(index)
      @pieces.find { |piece| piece.index == index }
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
