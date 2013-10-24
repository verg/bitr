module BitTorrentClient
  class Piece
    attr_reader :sha, :index, :length, :num_of_blocks

    def initialize(index, sha, length)
      raise ArgumentError, "filepiece sha must be 20 bits" unless String(sha).size == 20
      @index = index
      @sha = String(sha)
      @length = length
      @num_of_blocks = calculate_num_of_blocks
    end

    def calculate_num_of_blocks
      @length / BitTorrentClient::BLOCK_LENGTH
    end
  end
end
