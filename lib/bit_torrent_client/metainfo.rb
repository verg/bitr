require 'bencode'

module BitTorrentClient
  class Metainfo
    attr_reader :announce, :creation_date, :created_by, :encoding, :info_hash,
      :uri_encoded_info_hash, :info_dictionary

    def initialize(args)
      @announce = args.fetch("announce")
      @created_by = args["created by"]
      @creation_date = args["creation date"]
      @encoding = args["encoding"]
      @info_dictionary = args['info_dictionary'] || InfoDictionary.new(args['info'])
      @info_hash = args['bencoded_info']
    end

    def download_size
      @info_dictionary.download_size
    end

    def pieces
      @info_dictionary.pieces
    end

    def piece_length
      @info_dictionary.piece_length
    end

    def create_info_hash(info_hash)
      Digest::SHA1.new.digest(bencoded_info_hash)
    end
  end
end
