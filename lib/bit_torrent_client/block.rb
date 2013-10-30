module BitTorrentClient
  class Block
    attr_reader :status, :byte_offset, :absolute_start, :absolute_end, :byte_range

    def initialize(byte_offset, absolute_start=0)
      @byte_offset = byte_offset
      @status = :incomplete
      @absolute_start = absolute_start
      @absolute_end = absolute_start + BitTorrentClient::BLOCK_LENGTH
      @byte_range = @absolute_start...@absolute_end
    end


    def requested!
      @status = :requested
    end

    def complete!
      @status = :complete
    end

    def incomplete!
      @status = :incomplete
    end

    ["complete?", "incomplete?", "requested?"].each do |method|
      define_method method do |&block|
        symbolized_status = method[0...(method.size - 1)].to_sym
        symbolized_status == self.status
      end
    end

  end
  # BitTorrentClient::BLOCK_LENGTH)].pack("N")
end
