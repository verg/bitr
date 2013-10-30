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
      BLOCK_LENGTH = 4096
      piece = Piece.new(0, sha, length)
      expect(piece.num_of_blocks).to eq 4
    end

    describe "piece status" do
      it "intializes with an incomplete status" do
        piece = Piece.new(0, sha, length)
        expect(piece.status).to eq :incomplete
      end

      its "status is complete if all blocks are complete" do
        piece = Piece.new(0, sha, length)
        piece.blocks.each do |block|
          block.complete!
        end

        expect(piece.status).to eq :complete
        expect(piece.complete?).to be_true
      end
    end

    it "finds a block by its index" do
      piece = Piece.new(0, sha, length)
      block = piece.find_block(0)
      expect(block.byte_offset).to eq 0
    end

    it "raises an error when trying to find a non-existant block" do
      piece = Piece.new(0, sha, length)
      expect { piece.find_block(20) }.to raise_error ArgumentError
    end

    it "returns an array of incomplete blocks" do
      BLOCK_LENGTH = 4096
      piece = Piece.new(1, sha, length)
      expect(piece.incomplete_blocks.length).to eq 4
      block = piece.find_block(0)
      block.complete!
      expect(piece.incomplete_blocks.length).to eq 3
    end

    it "knows if any of it's blocks are incomplete" do
      BLOCK_LENGTH = 4096 * 4
      piece = Piece.new(0, sha, length)
      block = piece.find_block(0)
      block.complete!
      expect(piece.has_incomplete_blocks?).to be_false
      block.incomplete!
      expect(piece.has_incomplete_blocks?).to be_true
    end

  end

end
