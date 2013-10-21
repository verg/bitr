require_relative "../../../lib/bit_torrent_client/message_handler"
require_relative "../../spec_helper"

module BitTorrent
  class Message
    def initialize(string)

    end
  end

  describe MessageHandler do

    let(:empty_message_handler) { MessageHandler.new }
    let(:stream) { "\x13BitTorrent protocol\x00\x00\x00\x00\x00\x10\x00\x05+\x15\xCA+\xFDH\xCD\xD7m9\xECU\xA3\xAB\e\x8AW\x18\n\t-DE1220-QcZW4UlR6rD_\x00\x00\x00\v\x05\xFF\xFD\xB7\xEF\xF9\xFD\xFF\xFF\xFF\xFE\x00\x00\x00\x05\x04\x00\x00\x00\x0E\x00\x00\x00\x05\x04\x00\x00\x00\x11\x00\x00\x00\x05\x04\x00\x00\x00\x14\x00\x00\x00\x05\x04\x00\x00\x00\e\x00\x00\x00\x05\x04\x00\x00\x00%\x00\x00\x00\x05\x04\x00\x00\x00&\x00\x00\x00\x05\x04\x00\x00\x00." }
    let(:message_handler) { MessageHandler.new(stream) }
    it "has a buffer of message bytes" do
      expect(empty_message_handler.stream).to eq ''
    end

    it "handles the handshake as a special case" do
      message_handler.parse
      expect(handle_encoding(message_handler.stream)).to_not match(/BitTorrent protocol/)
      expect(message_handler.handshook?).to eq true
    end

    it "parses messages based on message length" do
      messages = message_handler.parse
      expect(messages.length).to eq 8
    end
  end
end
