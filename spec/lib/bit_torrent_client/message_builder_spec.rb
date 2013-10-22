require_relative "../../../lib/bit_torrent_client/message_builder"
require_relative "../../../lib/bit_torrent_client/message"
require_relative "../../../lib/bit_torrent_client/message_parser"
require_relative "../../spec_helper"

module BitTorrentClient
  describe MessageBuilder do
    let(:interested) { "\x00\x00\x00\x01\x02" }
    let(:keep_alive) { "\x00\x00\x00\x00" }
    let(:handshake) { "\x13BitTorrent protocol\x00\x00\x00\x00\x00\x00\x00\x00+\x15\xCA+\xFDH\xCD\xD7m9\xECU\xA3\xAB\e\x8AW\x18\n\t-DE1220-QcZW4UlR6rD_" }
    let(:request) { "\x00\x00\x00\x0d\x06\x00\x00\x00\x01\x00\x00\x00\x02\x00\x00\x00\x03" }

    it "can create :interested messages" do
      message = MessageBuilder.build(:interested)
      expect(message.to_s).to eq interested
    end

    it "can create :keep_alive messages" do
      message = MessageBuilder.build(:keep_alive)
      expect(message.to_s).to eq keep_alive
    end

    it "can create :request messages" do
      index =  "\x00\x00\x00\x01"
      begin_bytes = "\x00\x00\x00\x02"
      length = "\x00\x00\x00\x03"

      message = MessageBuilder.build(:request, index: index,
                                     begin: begin_bytes, length: length)
      expect(message.to_s).to eq request
    end

    it "can create handshake messages" do
      info_hash = "+\x15\xCA+\xFDH\xCD\xD7m9\xECU\xA3\xAB\e\x8AW\x18\n\t"
      client_id = "-DE1220-QcZW4UlR6rD_"

      message = MessageBuilder.build(:handshake, info_hash: info_hash, client_id: client_id)
      expect(handle_encoding(message.to_s)).to eq handle_encoding(handshake)
    end
  end
end
