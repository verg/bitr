module BitTorrentClient
  class TCPClient < EventMachine::Connection

    SIXTEEN_KB = 1024 * 16

    def initialize(opts={})
      super
      @peer = opts.fetch(:peer)
      @torrent = opts.fetch(:torrent)
      @my_peer_id = @torrent.my_peer_id
      @info_hash = @torrent.info_hash
      @message_handler = MessageHandler.new
    end

    def receive_data(data)
      p "Receiving data #{data}"
      messages = @message_handler.handle data
      @torrent.handle_messages(messages)
    end

    def exchange_handshake
      BitTorrentClient.log "Sending handshake"
      send_data(handshake_message)
    end

    def declare_interest
      BitTorrentClient.log "Declaring interest"
      send_data(interested_message)
    end

    def unbind
      BitTorrentClient.log "something disconnected"
      shutdown
    end

    def shutdown
      @socket.close if @socket
    end

    def handshake_message
      MessageBuilder.build(:handshake, info_hash: @info_hash,
                           client_id: @my_peer_id).to_s
    end

    def interested_message
      MessageBuilder.build(:interested).to_s
    end

    def request_message(index, length, begin_offset="\x00\x00\x00\x00")
      MessageBuilder.build(:request, index: index, length: length,
                                     begin: begin_offset).to_s
    end
  end
end
