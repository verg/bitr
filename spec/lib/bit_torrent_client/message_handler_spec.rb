require_relative "../../../lib/bit_torrent_client/message_handler"
require_relative "../../spec_helper"

module BitTorrentClient
  class Message
    def initialize(string)
    end
  end

  describe MessageHandler do

    let(:empty_message_handler) { MessageHandler.new }
    let(:stream) { "\x13BitTorrent protocol\x00\x00\x00\x00\x00\x10\x00\x05+\x15\xCA+\xFDH\xCD\xD7m9\xECU\xA3\xAB\e\x8AW\x18\n\t-DE1220-QcZW4UlR6rD_\x00\x00\x00\v\x05\xFF\xFD\xB7\xEF\xF9\xFD\xFF\xFF\xFF\xFE\x00\x00\x00\x05\x04\x00\x00\x00\x0E\x00\x00\x00\x05\x04\x00\x00\x00\x11\x00\x00\x00\x05\x04\x00\x00\x00\x14\x00\x00\x00\x05\x04\x00\x00\x00\e\x00\x00\x00\x05\x04\x00\x00\x00%\x00\x00\x00\x05\x04\x00\x00\x00&\x00\x00\x00\x05\x04\x00\x00\x00." }
    let(:message_handler) { MessageHandler.new }
    it "has a buffer of message bytes" do
      expect(empty_message_handler.stream).to eq ''
    end

    it "handles the handshake as a special case" do
      message_handler.handle(stream)
      expect(handle_encoding(message_handler.stream)).to_not match(/BitTorrent protocol/)
      expect(message_handler.handshook?).to eq true
    end

    it "only handles a complete handshake message" do
      partial_handshake = "\x13BitTorrent protocol\x00\x00\x00\x00\x00\x10\x00\x05+\x15"
      the_rest = "\xCA+\xFDH\xCD\xD7m9\xECU\xA3\xAB\e\x8AW\x18\n\t-DE1220-QcZW4UlR6rD_\x00"
      message_handler.handle(partial_handshake)
      expect(message_handler.handshook?).to be_false

      message_handler.handle(the_rest)
      expect(message_handler.handshook?).to be_true
      expect(message_handler.stream).to eq "\x00"
    end

    it "parses messages based on message length" do
      messages = message_handler.handle(stream)
      expect(messages.length).to eq 8
    end

    describe "#handle" do
      it "can add incomplete data to it's stream" do
        data = "data"
        handler = MessageHandler.new(handshook: true)

        expect(handler.stream).to be_empty
        handler.handle(data)
        expect(handler.stream).to eq data
      end

      it "returns messages if there is enough data" do
        handler = MessageHandler.new(handshook: true)
        incomplete_data = "\x00\x00\x00\v\x05\xFF"
        more_data = "\xFD\xB7\xEF\xF9\xFD\xFF\xFF\xFF\xFE\x00\x00"
        handler.handle(incomplete_data)
        expect(handler.stream).to eq incomplete_data

        expect(handler.handle(more_data).size).to eq 1
        expect(handler.stream).to eq "\x00\x00"
      end
    end
  end
end
