require_relative "../../../lib/bit_torrent_client/piece"
require_relative "../../../lib/bit_torrent_client"

module BitTorrentClient
  describe Piece do
    let(:sha) { %[\x12\x34\x56\x78\x9a\xbc\xde\xf1\x23\x45\x67\x89\xab\xcd\xef\x12\x34\x56\x78\x9a] }
    let(:length) { 16384 }
    it "stores a 20 bit sha1 hash of the file" do
      piece = Piece.new(0, sha, length)
      expect(piece.sha).to eq sha
    end

    it "stores the index of the piece" do
      piece = Piece.new(0, sha, length)
      expect(piece.index).to eq 0
    end

    it "raises an error if the sha is not 20 chars" do
      nineteen_bit_sha = %[\x12\x34\x56\x78\x9a\xbc\xde\xf1\x23\x45\x67\x89\xab\xcd\xef\x12\x34\x56\x78]
      expect { Piece.new(nineteen_bit_sha) }.to raise_error ArgumentError
    end

    it "has a length in bytes" do
      piece = Piece.new(0, sha, length)
      expect(piece.length).to eq 16384
    end

    it "calculates the number of blocks in a piece" do
      piece = Piece.new(0, sha, length)
      expect(piece.num_of_blocks).to eq 1
    end

    it "has a status"
  end
end
