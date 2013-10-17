class TCPClient
  def initialize(peer, client_id, info_hash)
    @peer = peer
    @client_id = client_id
    @info_hash = info_hash
  end

  def send_handshake
    require 'pry'; binding.pry
    socket = TCPSocket.new(@peer.ip, @peer.port)
    socket.write handshake_message
    socket.accept
    byte = socket.getbyte
    data = socket.read
    socket.close
  end

  def handshake_message
    {
      pstrlen:    '\x13',
      pstr:       'BitTorrent protocol',
      reserved:   '\x00\x00\x00\x00\x00\x00\x00\x00',
      info_hash:  @info_hash,
      peer_id:    @client_id
    }.values.join('')
  end
end
