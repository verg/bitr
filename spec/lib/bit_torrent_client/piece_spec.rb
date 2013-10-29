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
      it "has intializes with an incomplete status" do
        piece = Piece.new(0, sha, length)
        expect(piece.status).to eq :incomplete
      end

      its "staus can be set to complete" do
        piece = Piece.new(0, sha, length)

        piece.blocks.each do |byte_offset, block_status|
          piece.block_complete!(byte_offset)
        end

        expect(piece.status).to eq :complete
        expect(piece.complete?).to be_true
      end
    end

    describe "block status" do

      it "intializes with an array incomplete blocks" do
        piece = Piece.new(0, sha, length)
        piece.blocks.each do |byte_offset, block_status|
          expect(block_status).to be :incomplete
        end
      end

      its "blocks can be set to a requested status" do
        piece = Piece.new(0, sha, length)
        piece.block_requested!("\x00\x00\x00\x00")
        expect(piece.block_status("\x00\x00\x00\x00")).to eq :requested
      end

      its "blocks can be set to a complete status" do
        piece = Piece.new(0, sha, length)
        piece.block_complete!("\x00\x00\x00\x00")
        expect(piece.block_status("\x00\x00\x00\x00")).to eq :complete
      end

      its "blocks can be set to a incomplete status" do
        piece = Piece.new(0, sha, length)
        piece.block_complete!("\x00\x00\x00\x00")
        piece.block_incomplete!("\x00\x00\x00\x00")
        expect(piece.block_status("\x00\x00\x00\x00")).to eq :incomplete
      end

      it "raises an error when trying to set a non-existant byte offset" do
        piece = Piece.new(0, sha, length)
        expect { piece.block_complete!("not a block offset") }.to raise_error KeyError
      end
      it "returns an array of incomplete blocks" do
        BLOCK_LENGTH = 4096
        piece = Piece.new(0, sha, length)
        expect(piece.incomplete_blocks.length).to eq 4
        piece.block_complete!("\x00\x00\x00\x00")
        expect(piece.incomplete_blocks.length).to eq 3
      end
    end
  end
end
