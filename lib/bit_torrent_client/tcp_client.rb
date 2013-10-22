module BitTorrentClient
  class TCPClient

    SIXTEEN_KB = 1024 * 16

    def initialize(peer, client_id, info_hash)
      @peer = peer
      @client_id = client_id
      @info_hash = info_hash
    end

    def send_handshake
      socket = TCPSocket.new(@peer.ip, @peer.port)
      socket.write handshake_message
      # byte = socket.getbyte
      begin
        data = socket.read_nonblock(SIXTEEN_KB)
      rescue Errno::EAGAIN
        retry
      end
      data
    end

    def handshake_message
      MessageBuilder.build(:handshake, info_hash: @info_hash,
                           client_id: @client_id).to_s
    end
  end
end
