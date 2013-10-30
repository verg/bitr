module BitTorrentClient
  class DownloadableFile
    attr_reader :filename, :byte_size, :directories, :start_offset

    def initialize(args)
      @filename = args.fetch("filename")
      @directories = args.fetch("directories") { [] }
      @byte_size = args.fetch("byte_size")
      @start_offset = args.fetch("start_offset") { 0 }
    end

    def full_path
      if @directories.any?
        @directories.join('/') << "/#{@filename}"
      else
        @filename
      end
    end

    def byte_range
      @start_offset...end_offset
    end

    def end_offset
      @start_offset + @byte_size
    end

    def has_byte?(absolute_byte)
      byte_range.include? absolute_byte
    end
  end
end

# def contains_thing(absolute_offset)
