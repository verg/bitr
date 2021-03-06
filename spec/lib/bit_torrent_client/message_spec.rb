require_relative "../../../lib/bit_torrent_client/message"
require_relative "../../../lib/bit_torrent_client/message_parser"

module BitTorrentClient
  describe Message do
    describe "initializes from a string" do
      let(:msg_1) { "\x00\x00\x00\v\x05\xFF\xFD\xB7\xEF\xF9\xFD\xFF\xFF\xFF\xFE" }
      let(:msg_2) { "\x00\x00\x00\x05\x04\x00\x00\x00\x0E" }
      let(:msg_3) { "\x00\x00\x00\x05\x04\x00\x00\x00\x11" }
      let(:msg_4) { "\x00\x00\x00\x05\x04\x00\x00\x00." }

      it "has a type" do
        message = Message.new(msg_1)
        expect(message.type).to eq :bitfield
      end

      it "has a payload" do
        message = Message.new(msg_2)
        expect(message.payload).to eq "\x00\x00\x00\x0E"
      end

      let(:piece) { "\x00\x00\x00\x01\x07\x00\x00\x00\x0E\x00\x00\x00\x00\x00" }
      it "has a block" do
        message = Message.new(piece)
        expect(message.block).to eq "\x00"
      end

      it "responds to to_s" do
        message = Message.new(msg_1)
        expect(message.to_s).to eq msg_1
      end

      it "has a pieces" do
        message = Message.new(msg_2)
        expect(message.piece_index).to eq "\x00\x00\x00\x0E"
      end

      it "can have a byte offset" do
        message = Message.new(piece)
        expect(message.byte_offset).to eq "\x00\x00\x00\x00"
      end
    end
  end
end
