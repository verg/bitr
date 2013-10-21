require_relative "../../../lib/bit_torrent_client/message_parser"

module BitTorrentClient
  describe MessageParser do
    describe "bitfield messages" do
      let(:bitfield) { "\x00\x00\x00\v\x05\xFF\xFB\xFF\xFF\xFF\xEE\x7F\xFD\xBF\xEE" }
      let(:size_of_length_prefix) { 4 }

      it "finds the messages length" do
        parser = MessageParser.new(bitfield)
        expect(parser.length).to eq bitfield.size - size_of_length_prefix
      end

      it "identifies when a message is a handshake" do
        parser = MessageParser.new(bitfield)
        expect(parser.type).to eq :bitfield
      end
    end
  end
end
