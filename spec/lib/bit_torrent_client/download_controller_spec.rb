require_relative "../../../lib/bit_torrent_client/download_controller"

module BitTorrentClient
  describe DownloadController do
    let(:socket) { double("tcp connection") }
    let(:controller) { DownloadController.new() }

    describe "tracking outstaning requests" do
      it "starts with no connections" do
        expect(controller.pending_requests).to eq 0
      end
      it "increments pending requests when a new request is made"
      it "decrements pending requests when a piece is finsished"
    end

    it "has a socket" do
      expect(controller.socket).to
    end
    it "holds onto a peers collection"
    it "holds onto the status of pieces"

    it "starts requesting pieces when it has at least one peer"

    #  socket: conn, peice: current stata, peer: haves

    it "can recieve a new socket"
    it "can remove a socket"

    it "requests pieces we need"
    it "makes requests upto the max request number"
    it "requests missing blocks"
    it "makes new requests when other pieces are completed"
  end
end
