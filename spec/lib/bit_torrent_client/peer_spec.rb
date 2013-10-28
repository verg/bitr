require_relative "../../../lib/bit_torrent_client/peer"

module BitTorrentClient
  describe Peer do
    let(:peer) { Peer.new({:ip=>"74.212.183.186", :port=>6881}) }
    let(:bitfield) { "\xff\xff\x2f\xf6\xff\xff\xff\xf7\xdf\xfe" }

    it "has a choking status that can be set" do
      expect(peer.choking?).to be true
      peer.choking = false
      expect(peer.choking?).to be false
    end

    it "has a interested status" do
      expect(peer.interested?).to be false
      peer.interested = true
      expect(peer.interested?).to be true
    end

    it "has an ip address" do
      expect(peer.ip).to eq '74.212.183.186'
    end

    it "has a port" do
      expect(peer.port).to eq 6881
    end

    it "translates a bitfield into pieces it has or does not have" do
      has_piece_index = 0
      no_piece_index = 16
      peer.process_bitfield(bitfield)
      expect(peer.has_piece?(has_piece_index)).to be true
      expect(peer.has_piece?(no_piece_index)).to be false
    end

    it "updates the pieces it has by that piece index" do
      piece_index = 16
      peer.process_bitfield(bitfield)
      peer.has_piece_at(piece_index)
      expect(peer.has_piece?(piece_index)).to eq true
    end

  end
end
