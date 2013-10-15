module BitTorrentClient
  class DownloadableFile
    attr_reader :filename, :byte_size, :directories

    def initialize(filename, directories=[], byte_size)
      @filename = filename
      @directories = directories
      @byte_size = byte_size
    end

    def full_path
      if @directories.any?
        @directories.join('/') << "/#{@filename}"
      else
        @name
      end
    end
  end
end
