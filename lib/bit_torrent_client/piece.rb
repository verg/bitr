module BitTorrentClient
  class Piece
    attr_reader :sha, :index, :length, :num_of_blocks, :blocks

    def initialize(index, sha, length)
      raise ArgumentError, "filepiece sha must be 20 bits" unless String(sha).size == 20
      @index = index
      @sha = String(sha)
      @length = length
      @num_of_blocks = calculate_num_of_blocks
      @blocks = []
      generate_blocks
    end

    def status
      if all_blocks_complete?
        :complete
      else
        :incomplete
      end
    end

    def complete?
      status == :complete
    end

    def find_block(offset)
      arg_error = -> { raise ArgumentError }
      @blocks.find(arg_error) { |block| block.byte_offset == offset }
    end

    def incomplete_blocks
      @blocks.select { |block| block.incomplete? }
    end

    def has_incomplete_blocks?
      @blocks.any? { |block| block.incomplete? }
    end

    def next_byte_offset
      incomplete_blocks.keys.first
    end

    private

    def generate_blocks
      @num_of_blocks.times do |index|
        @blocks << Block.new(index)
      end
    end

    def all_blocks_complete?
       @blocks.none? { |block| !block.complete? }
    end

    def calculate_num_of_blocks
      @length / BitTorrentClient::BLOCK_LENGTH
    end

  end
end
