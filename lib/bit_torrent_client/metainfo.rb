module BitTorrentClient
  class Metainfo
    attr_reader :announce, :creation_date, :created_by, :encoding

    def initialize(args)
      @announce = args.fetch("announce")
      @created_by = args["created by"]
      @creation_date = args["creation date"]
      @encoding = args["encoding"]
      #TODO handle torrents with multiple files (don't currently have a ex torrent)
      @info_dictionary = InfoDictionary.new(args['info'])
    end

    def pieces
      @info_dictionary.pieces
    end

    def piece_length
      @info_dictionary.piece_length
    end

    def filename
      @info_dictionary.filename
    end

    def filelength
      @info_dictionary.filelength
    end
  end

  class InfoDictionary
    attr_reader :pieces, :piece_length, :filename, :filelength

    #TODO handle torrents with multiple files (don't currently have a ex torrent)
    def initialize(args)
      @pieces = args.fetch("pieces")
      @piece_length = args.fetch("piece length")
      @filename = args.fetch("name")
      @filelength = args.fetch("length")
    end
  end
end
