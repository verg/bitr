require_relative "bit_torrent_client/metainfo"
require_relative "bit_torrent_client/http_client"
require_relative "bit_torrent_client/metainfo_parser"
require_relative "bit_torrent_client/info_dictionary"
require_relative "bit_torrent_client/piece"
require_relative "bit_torrent_client/peer"
require_relative "bit_torrent_client/downloadable_file"
require_relative "bit_torrent_client/announce_response"
require_relative "bit_torrent_client/tcp_client"
require_relative "bit_torrent_client/message_builder"
require_relative "bit_torrent_client/message"
require_relative "bit_torrent_client/message_parser"
require_relative "bit_torrent_client/message_handler"

module BitTorrentClient
  MY_PEER_ID = "-RV0001-#{ 12.times.map { rand(10) }.join}"
  class << self
    def start(torrent_file=nil)
      torrent = torrent_file || ARGV[0]
      Torrent.new(torrent)
    end
  end

  class Torrent
    attr_reader :torrent_file, :uploaded_bytes, :downloaded_bytes, :announce_url,
      :info_hash, :my_peer_id

    def initialize(torrent_file)
      @torrent_file = torrent_file
      @metainfo = read_torrent_file
      @uploaded_bytes = 0
      @downloaded_bytes = 0
      @announce_url = @metainfo.announce
      @info_hash = @metainfo.info_hash
      @my_peer_id = MY_PEER_ID
    end

    def bytes_left
      @metainfo.download_size - @downloaded_bytes
    end

    def read_torrent_file
      parsed_metainfo = MetainfoParser.parse(torrent_file)
      Metainfo.new(parsed_metainfo)
    end
  end
end
