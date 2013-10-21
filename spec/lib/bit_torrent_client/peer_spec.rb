require_relative "../../../lib/bit_torrent_client/peer"

module BitTorrentClient
  describe Peer do
    let(:peer) { Peer.new({:ip=>"74.212.183.186", :port=>6881}) }

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
  end
end
