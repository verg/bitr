require_relative "../../../lib/bit_torrent_client/piece_collection"
require_relative "../../../lib/bit_torrent_client/piece"

module BitTorrentClient
  describe PieceCollection do
    before { BLOCK_LENGTH = 4096 }
    let(:index) { 0 }
    let(:byte_index) { "\x00\x00\x00\x00" }
    let(:sha) { %[\x12\x34\x56\x78\x9a\xbc\xde\xf1\x23\x45\x67\x89\xab\xcd\xef\x12\x34\x56\x78\x9a] }
    let(:length) { 1 }

    it "contains many pieces" do
      piece = Piece.new(index, sha, length)
      pieces = PieceCollection.new
      pieces << piece
      expect(pieces.length).to eq 1
    end

    it "returns an array of incomplete pieces" do
      complete = Piece.new(index, sha, length)
      incomplete = Piece.new(index, sha, length)

      complete.stub(:complete?) { true }
      incomplete.stub(:complete?) { false }

      pieces = PieceCollection.new
      pieces << incomplete
      pieces << complete
      expect(pieces.incomplete).to include incomplete
    end

    it "returns an array of completed pieces" do
      complete = Piece.new(index, sha, length)
      incomplete = Piece.new(index, sha, length)

      complete.stub(:complete?) { true }
      incomplete.stub(:complete?) { false }

      pieces = PieceCollection.new
      pieces << incomplete
      pieces << complete
      expect(pieces.complete).to include complete
    end

    it "knows if the entire download is complete" do
      piece_1 = Piece.new(index, sha, length)
      piece_2 = Piece.new(index, sha, length)

      piece_1.stub(:complete?) { true }
      piece_2.stub(:complete?) { true }

      pieces = PieceCollection.new [piece_1, piece_2]
      expect(pieces.download_complete?).to be true

      incomplete = Piece.new(index, sha, length)
      incomplete.stub(:complete?) { false }
      pieces << incomplete
      expect(pieces.download_complete?).to be false
    end

    it "can find a specfic piece by index" do
      piece = Piece.new(index, sha, length)
      pieces = PieceCollection.new
      pieces << piece
      expect(pieces.find(index)).to eq piece
    end

    it "can find a specific piece by byte index or integer index" do
      piece = Piece.new(index, sha, length)
      pieces = PieceCollection.new
      pieces << piece
      expect(pieces.find(index)).to eq piece
      expect(pieces.find(byte_index)).to eq piece
    end

  end
end
