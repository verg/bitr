require_relative "../../../lib/bit_torrent_client/piece_collection"
require_relative "../../../lib/bit_torrent_client/piece"
module BitTorrentClient
  describe PieceCollection do
    it "contains many pieces"
    it "enumerates over pieces"
    it "returns an array of incomplete pieces"
    it "returns an array of completed pieces"
    it "knows if the entire download is complete"
  end
end
