module BitTorrentClient
  class Metainfo
    attr_reader :announce, :creation_date, :created_by, :encoding

    def initialize(args)
      @announce = args.fetch("announce")
      @created_by = args["created by"]
      @creation_date = args["creation date"]
      @encoding = args["encoding"]
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
end
