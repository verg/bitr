require 'bencode'

module BitTorrentClient
  class Metainfo
    attr_reader :announce, :creation_date, :created_by, :encoding, :info_hash

    def initialize(args)
      @announce = args.fetch("announce")
      @created_by = args["created by"]
      @creation_date = args["creation date"]
      @encoding = args["encoding"]
      @info_dictionary = args['info_dictionary'] || InfoDictionary.new(args['info'])
      @info_hash = create_info_hash(args['info'])
    end

    def pieces
      @info_dictionary.pieces
    end

    def create_info_hash(info_hash)
      Digest::SHA1.new.digest(info_hash.bencode)
    end
  end
end
