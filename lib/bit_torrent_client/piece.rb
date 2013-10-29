module BitTorrentClient
  class Piece
    attr_reader :sha, :index, :length, :num_of_blocks, :blocks

    def initialize(index, sha, length)
      raise ArgumentError, "filepiece sha must be 20 bits" unless String(sha).size == 20
      @index = index
      @sha = String(sha)
      @length = length
      @num_of_blocks = calculate_num_of_blocks
      @blocks = {}
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

    def calculate_num_of_blocks
      @length / BitTorrentClient::BLOCK_LENGTH
    end

    def block_status(offset)
      @blocks.fetch(offset){ raise KeyError, "no byte offset, #{offset}" }
    end

    def block_requested!(byte_offset)
      ensure_byte_offset_exists(byte_offset)
      @blocks[byte_offset] = :requested
    end

    def block_complete!(byte_offset)
      ensure_byte_offset_exists(byte_offset)
      @blocks[byte_offset] = :complete
    end

    def block_incomplete!(byte_offset)
      ensure_byte_offset_exists(byte_offset)
      @blocks[byte_offset] = :incomplete
    end

    def incomplete_blocks
      @blocks.select { |block, status| status == :incomplete }
    end

    def next_byte_offset
      incomplete_blocks.first.key
    end

    private

    def ensure_byte_offset_exists(offset)
      raise KeyError, "no byte offset, #{offset}" unless @blocks.has_key?(offset)
    end

    def generate_blocks
      @num_of_blocks.times do |index|
        byte_offset = [(index * BitTorrentClient::BLOCK_LENGTH)].pack("N")
        @blocks[byte_offset] = :incomplete
      end
    end

    def all_blocks_complete?
       @blocks.none? { |offset, status| status != :complete }
    end
  end
end

{ "\x00\x00\x00\x00" => :incomplete }
{ "\x00\x00\x00\x00" => :requested }
{ "\x00\x00\x00\x00" => :complete }
