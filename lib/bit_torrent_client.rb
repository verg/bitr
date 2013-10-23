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
  CLIENT_ID = "-RV0001-#{ 12.times.map { rand(10) }}"
  class << self
    def start(torrent_file=nil)
      torrent = torrent_file || ARGV[0]
      Torrent.new(torrent)
    end

    def random_id
    end
  end

  class Torrent
    attr_reader :torrent_file, :uploaded_bytes, :downloaded_bytes
    def initialize(torrent_file)
      @torrent_file = torrent_file
      @metainfo = read_torrent_file
      @uploaded_bytes = 0
      @downloaded_bytes = 0
      # response = HTTPClient.new(CLIENT_ID).get_start_event(@metainfo)
    end

    def bytes_left
      @metainfo.download_size - @downloaded_bytes
    end

    def read_torrent_file
      metainfo_hash = MetainfoParser.parse(torrent_file)
      Metainfo.new(metainfo_hash)
    end
  end
end
