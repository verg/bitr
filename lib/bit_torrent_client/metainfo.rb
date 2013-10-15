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
  end
end
