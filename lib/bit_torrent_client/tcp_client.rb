module BitTorrentClient
  class TCPClient

    SIXTEEN_KB = 1024 * 16

    def initialize(peer, client_id, info_hash)
      @peer = peer
      @client_id = client_id
      @info_hash = info_hash
      @socket = TCPSocket.new(@peer.ip, @peer.port)
    end

    def exchange_handshake
      @socket.write handshake_message
      # byte = socket.getbyte
      begin
        data = @socket.read_nonblock(SIXTEEN_KB)
      rescue Errno::EAGAIN
        retry
      end
      data
    end

    def declare_interest
      @socket.write interested_message
      begin
        data = @socket.read_nonblock(SIXTEEN_KB)
      rescue Errno::EAGAIN
        retry
      end
      data
    end

    def shutdown
      @socket.close if @socket
    end

    def handshake_message
      MessageBuilder.build(:handshake, info_hash: @info_hash,
                           client_id: @client_id).to_s
    end

    def interested_message
      MessageBuilder.build(:interested).to_s
    end
  end
end
