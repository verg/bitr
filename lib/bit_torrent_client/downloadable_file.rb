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

    def byte_overlap?(other_byte_range)
      overlaps?(other_byte_range)
    end

    private

    def overlaps?(other)
      byte_range.cover?(other.first) || other.cover?(byte_range.first)
    end
  end
end

# def contains_thing(absolute_offset)
