module BitTorrentClient
  class DownloadableFile
    attr_reader :filename, :byte_size, :directories

    def initialize(args)
      @filename = args.fetch("filename")
      @directories = args.fetch("directories") { [] }
      @byte_size = args.fetch("byte_size")
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
