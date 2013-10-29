require_relative "../../../lib/bit_torrent_client/download_controller"
require_relative "../../../lib/bit_torrent_client/piece_collection"
require_relative "../../../lib/bit_torrent_client/config"

module BitTorrentClient
  describe DownloadController do
    let(:socket) { double("tcp connection") }
    let(:socket_2) { double("tcp connection") }
    let(:piece) {
      double("piece",
             incomplete_blocks: [:block1, :block2],
             :complete? => false,
             :index => "\x00\x00\x00\x00",
             :next_byte_offset => "\x00\x00\x00\x00")
    }
    let(:piece_1) { double("piece one", :complete? => false) }
    let(:piece_2) { double("piece two", :complete? => false) }
    let(:pieces) { PieceCollection.new([piece, piece_1, piece_2]) }
    let(:controller) { DownloadController.new(pieces) }

    describe "tracking outstaning requests" do
      it "starts with no connections" do
        expect(controller.pending_requests).to eq 0
      end
      it "increments pending requests when a new request is made"
      it "decrements pending requests when a piece is finsished"
    end

    it "knows if it has any sockets" do
      expect(controller.has_sockets?).to be false
      controller.add_socket(socket)
      expect(controller.has_sockets?).to be true
    end

    it "knows if it needs pieces"

    it "knows if it's maxed out its connections"

    it "knows if it can make another request"

    describe "#tick" do
      it "sends a request if has sockets, needs pieces, and hasn't maxed connections" do
        controller.should_receive(:tick)
        controller.add_socket(socket)
      end
    end

    describe "sockets" do
      it "has an array of sockets" do
        expect(controller.sockets.length).to eq 0
      end
      it "can recieve a new socket" do
        socket.stub(:request_piece)
        controller.add_socket(socket)
        expect(controller.sockets.length).to eq 1
      end

      it "can remove a socket" do
        socket.stub(:request_piece)
        socket_2.stub(:request_piece)
        controller.add_socket(socket)
        controller.add_socket(socket_2)
        controller.remove_socket(socket)
        expect(controller.sockets.length).to eq 1
      end
    end

    describe "tracking pieces" do

      it "holds onto the status of pieces" do
        expect(controller.pieces.length).to eq 3
      end

      xit "starts requesting pieces when it has at least one socket" do
        socket.should_receive(:tick)
        controller.add_socket(socket)
      end

      it "determines the next piece we want" do
        expect(controller.next_piece).to eq piece
      end

      #  socket: conn, peice: current stata, peer: haves

      it "requests pieces we need"

    end
    it "makes requests upto the max request number"
    it "requests missing blocks"
    it "makes new requests when other pieces are completed"
  end
end
