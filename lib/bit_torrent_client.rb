require 'eventmachine'
require_relative "bit_torrent_client/metainfo"
require_relative "bit_torrent_client/http_client"
require_relative "bit_torrent_client/metainfo_parser"
require_relative "bit_torrent_client/info_dictionary"
require_relative "bit_torrent_client/piece"
require_relative "bit_torrent_client/piece_collection"
require_relative "bit_torrent_client/block"
require_relative "bit_torrent_client/peer"
require_relative "bit_torrent_client/downloadable_file"
require_relative "bit_torrent_client/announce_response"
require_relative "bit_torrent_client/tcp_client"
require_relative "bit_torrent_client/message_builder"
require_relative "bit_torrent_client/message"
require_relative "bit_torrent_client/message_parser"
require_relative "bit_torrent_client/message_handler"
require_relative "bit_torrent_client/download_controller"
require_relative "bit_torrent_client/config"

module BitTorrentClient
  class << self
    def start(torrent_file=nil, opts={})
      @print_log = opts.fetch(:print_log) { false }
      torrent = torrent_file || ARGV[0]
      @torrent = Torrent.new(torrent)
      @torrent.announce_to_tracker
      @torrent.get_peers
      the_right_peer = @torrent.peers.select { |peer| peer.ip == "96.126.104.219" }.first
      # @torrent.connect_to(the_right_peer)
      @torrent.peers.each do |peer|
        @torrent.connect_to(peer)
      end
      @torrent
    end

    def log(messsage)
      p messsage if @print_log
    end
  end

  class Torrent
    attr_reader :torrent_file, :uploaded_bytes, :downloaded_bytes, :announce_url,
      :info_hash, :my_peer_id, :my_port, :peers, :piece_length, :pieces

    def initialize(torrent_file)
      @torrent_file = torrent_file
      @metainfo = read_torrent_file
      @piece_length = @metainfo.piece_length
      @uploaded_bytes = 0
      @downloaded_bytes = 0
      @announce_url = @metainfo.announce
      @announce_response = nil
      @info_hash = @metainfo.info_hash
      @pieces = @metainfo.pieces
      @download_controller = DownloadController.new(@pieces)
      @my_peer_id = MY_PEER_ID
      @my_port = MY_PORT
      @peers = []
      @have_messages = []
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
      socket = EM.connect(peer.ip, peer.port,  TCPClient,
                           {torrent: self, peer: peer })
      socket.exchange_handshake
    end


    def handle_messages(messages, socket)
      messages.each do |message|
        BitTorrentClient.log "Received #{message.type}"
        case message.type
        when :handshake
          EM.next_tick { socket.declare_interest }
        when :bitfield
          socket.peer.process_bitfield(message.bitfield)
        when :unchoke
          # TODO set is_choking state on peer to false
          @download_controller.add_socket(socket)
          @download_controller.tick
        when :have
          socket.peer.has_piece_at message.piece_index
        when :piece
          @download_controller.handle_piece_message(message)
          piece = @pieces.find(message.piece_index)
          # TODO: extract this unpacking
          block = piece.find_block(message.byte_offset.unpack("N*").first)
          block.complete!
          @download_controller.tick
        end
      end
      BitTorrentClient.log "===Batch of messages handled==="
    end
  end
end
