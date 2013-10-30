require_relative "../../../lib/bit_torrent_client/block"
require_relative "../../../lib/bit_torrent_client/config"

module BitTorrentClient
  describe Block do
    let(:byte_offset) { 0 }

    it "has a byte_offset" do
      block = Block.new(byte_offset)
      expect(block.byte_offset).to eq 0
    end

    describe "status" do
      it "initializes to incomplete" do
        block = Block.new(byte_offset)
        expect(block.status).to eq :incomplete
        expect(block.incomplete?).to be_true
      end

      it "can be set to requested status" do
        block = Block.new(byte_offset)
        block.requested!
        expect(block.status).to eq :requested
        expect(block.requested?).to be_true
      end

      it "can be set to a complete status" do
        block = Block.new(byte_offset)
        block.complete!
        expect(block.status).to eq :complete
        expect(block.complete?).to be_true
      end

      it "can be set to an incomplete status" do
        block = Block.new(byte_offset)
        block.complete!
        block.incomplete!
        expect(block.status).to eq :incomplete
        expect(block.incomplete?).to be_true
      end

      describe "byte range" do
        it "has an absolute_start reflecting # of bytes from beginning of torrent" do
          byte_offsets = [0, 16384]
          current_piece_index = 0
          piece_length = 16384 * 2
          blocks = byte_offsets.map do |byte_offset|
            absolute_start = (piece_length * current_piece_index) + byte_offset
            Block.new(byte_offset, absolute_start)
          end
          expect(blocks.first.absolute_start).to eq 0
          expect(blocks.last.absolute_start).to eq 16384
        end

        it "has an absolute_end reflecting the # of bytes from beginning of torrent" do
          block = Block.new(byte_offset)
          expect(block.absolute_start).to eq 0
          expect(block.absolute_end).to eq 16384
        end
      end
    end
  end
end
