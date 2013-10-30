require_relative "../../../lib/bit_torrent_client/block"

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

    end
  end
end
