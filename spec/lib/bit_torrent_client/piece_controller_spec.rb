require_relative "../../../lib/bit_torrent_client/piece_controller"

module BitTorrentClient
  describe PieceController do
    it "starts requesting pieces when it has at least one peer"
    it "requests pieces we need"
    it "makes requests upto the max request number"
    it "requests missing blocks"
    it "makes new requests when other pieces are completed"
  end
end
