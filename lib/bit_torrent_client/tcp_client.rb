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
    {
      pstrlen:    "\x13",
      pstr:       "BitTorrent protocol",
      reserved:   "\x00\x00\x00\x00\x00\x00\x00\x00",
      info_hash:  "#{@info_hash}",
      peer_id:    "#{@client_id}"
    }.values.join("")
  end
end
