module BitTorrentClient
  class Piece
    attr_reader :sha

    def initialize(sha)
      raise ArgumentError, "filepiece sha must be 20 bits" unless String(sha).size == 20
      @sha = String(sha)
    end
  end
end
