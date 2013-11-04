require 'bencode'

module BitTorrentClient
  class MetainfoParser
    def self.parse(torrent)
      begin
        torrent = File.read(torrent)
      rescue ArgumentError
        torrent = torrent
      end
      metainfo_hash = BEncode::Parser.new(torrent).parse!
      metainfo_hash['bencoded_info'] = Digest::SHA1.new.digest metainfo_hash['info'].bencode
      metainfo_hash
    end
  end
end
