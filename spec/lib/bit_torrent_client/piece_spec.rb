require_relative "../../../lib/bit_torrent_client/piece"

module BitTorrentClient
  describe Piece do
    it "stores a 20 bit sha1 hash of the file" do
      sha = %[\x12\x34\x56\x78\x9a\xbc\xde\xf1\x23\x45\x67\x89\xab\xcd\xef\x12\x34\x56\x78\x9a]
      piece = Piece.new(sha)
      expect(piece.sha).to eq sha
    end

    it "raises an error if the sha is not 20 chars" do
      nineteen_bit_sha = %[\x12\x34\x56\x78\x9a\xbc\xde\xf1\x23\x45\x67\x89\xab\xcd\xef\x12\x34\x56\x78]
      expect { Piece.new(nineteen_bit_sha) }.to raise_error ArgumentError
    end

    it "has a status"
  end
end
