require 'bencode'

module BitTorrentClient
  class MetainfoParser
    def self.parse(torrent)
      metainfo_hash = BEncode::Parser.new(torrent).parse!
      metainfo_hash['info']["pieces"] = metainfo_hash['info']['pieces'].encode('UTF-8', 'binary', invalid: :replace, undef: :replace)
    end
  end
end
