require 'bencode'
require 'forwardable'

module BitTorrentClient
  class Metainfo
    attr_reader :announce, :creation_date, :created_by, :encoding, :info_hash,
      :uri_encoded_info_hash, :info_dictionary

    extend Forwardable
    def_delegators :info_dictionary, :download_size, :pieces, :piece_length

    def initialize(args)
      @announce = args.fetch("announce")
      @created_by = args["created by"]
      @creation_date = args["creation date"]
      @encoding = args["encoding"]
      @info_dictionary = args['info_dictionary'] || InfoDictionary.new(args['info'])
      @info_hash = args['bencoded_info']
    end

    def create_info_hash(info_hash)
      Digest::SHA1.new.digest(bencoded_info_hash)
    end
  end
end
