require 'eventmachine'
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
  MY_PORT    =  6881
  class << self
    def start(torrent_file=nil)
      torrent = torrent_file || ARGV[0]
      @torrent = Torrent.new(torrent)
      @torrent.announce_to_tracker
      @torrent.get_peers
      the_right_peer = @torrent.peers.select { |peer| peer.ip == "96.126.104.219" }.first
      @torrent.connect_to(the_right_peer)
      @torrent
    end
  end

  class Torrent
    attr_reader :torrent_file, :uploaded_bytes, :downloaded_bytes, :announce_url,
      :info_hash, :my_peer_id, :my_port, :peers

    def initialize(torrent_file)
      @torrent_file = torrent_file
      @metainfo = read_torrent_file
      @uploaded_bytes = 0
      @downloaded_bytes = 0
      @announce_url = @metainfo.announce
      @announce_response = nil
      @info_hash = @metainfo.info_hash
      @my_peer_id = MY_PEER_ID
      @my_port = MY_PORT
      @peers = []
    end

    def bytes_left
      @metainfo.download_size - @downloaded_bytes
    end

    def read_torrent_file
      parsed_metainfo = MetainfoParser.parse(torrent_file)
      Metainfo.new(parsed_metainfo)
    end

    def announce_to_tracker
      @announce_response = HTTPClient.new(self).get_start_event
    end

    def get_peers
      @peers = @announce_response.peers.map { |peer| Peer.new(peer) }
    end

    def connect_to(peer)
      @socket = EM.connect(peer.ip, peer.port,  TCPClient,
                          {torrent: self, peer: peer })
      @socket.exchange_handshake
    end

    def handle_messages(messages)
      messages.each do |message|
        puts "Received #{message.type}"
        case message.type
        when :handshake
          EM.next_tick { @socket.declare_interest }
        end
      end
      puts "===Batch of messages handled==="
    end
  end
end
