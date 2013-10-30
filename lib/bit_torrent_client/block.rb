module BitTorrentClient
  class Block
    attr_reader :status, :byte_offset

    def initialize(byte_offset)
      @byte_offset = byte_offset
      @status = :incomplete
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
end
