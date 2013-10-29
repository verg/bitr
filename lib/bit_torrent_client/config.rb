module BitTorrentClient
  MY_PEER_ID = "-RV0001-#{ 12.times.map { rand(10) }.join}"
  MY_PORT    =  6881
  BLOCK_LENGTH = 16384

  def self.hex_block_bytes
    [BLOCK_LENGTH].pack("N*")
  end

end
