require 'bencode'

module BitTorrentClient
  class MetainfoParser
    def self.parse(torrent)
      metainfo_hash = BEncode::Parser.new(torrent).parse!
    end
  end
end
