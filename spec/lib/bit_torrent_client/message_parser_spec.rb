require_relative "../../../lib/bit_torrent_client/message_parser"

module BitTorrentClient
  describe MessageParser do
    describe "bitfield messages" do
      let(:bitfield) { "\x00\x00\x00\v\x05\xFF\xFB\xFF\xFF\xFF\xEE\x7F\xFD\xBF\xEE" }
      let(:keep_alive) { "\x00\x00\x00\x00" }
      let(:choke) { "\x00\x00\x00\x01\x00" }
      let(:unchoke) { "\x00\x00\x00\x01\x01" }
      let(:interested) { "\x00\x00\x00\x01\x02" }
      let(:not_interested) { "\x00\x00\x00\x01\x03" }
      let(:port) { "\x00\x00\x00\x01\x09" }
      let(:size_of_length_prefix) { 4 }

      it "finds the messages length" do
        parser = MessageParser.new(bitfield)
        expect(parser.length).to eq bitfield.size - size_of_length_prefix
      end

      it "identifies a bitfield message" do
        parser = MessageParser.new(bitfield)
        expect(parser.type).to eq :bitfield
      end

      it "identifies a keep-alive message" do
        parser = MessageParser.new(keep_alive)
        expect(parser.type).to eq :keep_alive
      end

      it "identifies a choke message" do
        parser = MessageParser.new(choke)
        expect(parser.type).to eq :choke
      end

      it "identifies an unchoke message" do
        parser = MessageParser.new(unchoke)
        expect(parser.type).to eq :unchoke
      end

      it "identifies an interested message" do
        parser = MessageParser.new(interested)
        expect(parser.type).to eq :interested
      end

      it "identifies a not interested message" do
        parser = MessageParser.new(not_interested)
        expect(parser.type).to eq :not_interested
      end

      it "identifies a port message" do
        parser = MessageParser.new(port)
        expect(parser.type).to eq :port
      end

      describe "non-piece related messages" do
        it "has an empty piece index" do
          parser = MessageParser.new(bitfield)
          expect(parser.piece_index).to eq ""
        end
      end

      describe "piece-related messages" do
        let(:have) { "\x00\x00\x00\x05\x04\x00\x00\x00\x0E" }
        let(:request) { "\x00\x00\x00\x01\x06\x00\x00\x00\x0E" }
        let(:piece) { "\x00\x00\x00\x01\x07\x00\x00\x00\x0E" }
        let(:cancel) { "\x00\x00\x00\x01\x08\x00\x00\x00\x0E" }

        it "identifies a have message" do
          parser = MessageParser.new(have)
          expect(parser.type).to eq :have
          expect(parser.piece_index).to eq "\x00\x00\x00\x0E"
        end

        it "identifies a request message" do
          parser = MessageParser.new(request)
          expect(parser.type).to eq :request
          expect(parser.piece_index).to eq "\x00\x00\x00\x0E"
        end

        it "identifies a piece message" do
          parser = MessageParser.new(piece)
          expect(parser.type).to eq :piece
          expect(parser.piece_index).to eq "\x00\x00\x00\x0E"
        end

        it "identifies a cancel message" do
          parser = MessageParser.new(cancel)
          expect(parser.type).to eq :cancel
          expect(parser.piece_index).to eq "\x00\x00\x00\x0E"
        end
      end

      describe "#payload" do
        it "is empty for a keep-alive message" do
          parser = MessageParser.new(keep_alive)
          expect(parser.payload).to be_empty
        end
      end
    end
  end
end
