require_relative "../../lib/bit_torrent_client"
require_relative "../../lib/bit_torrent_client/metainfo_parser"

module BitTorrentClient
  describe BitTorrentClient do
    let(:torrent_file) {"spec/fixtures/flagfromserver.torrent"}
    it "initializes with a torrent file" do
      torrent = BitTorrentClient.start(torrent_file)
      expect(torrent.torrent_file).to eq(torrent_file)

      expect(torrent.uploaded_bytes).to eq(0)
      expect(torrent.downloaded_bytes).to eq(0)
      expect(torrent.bytes_left).to eq 1277987
    end

    it "generates a random client id" do
      expect(BitTorrentClient::CLIENT_ID).to include("-RV0001-")
    end

    xit "sends the torrent file to be parsed" do
      MetainfoParser.should_receive(:parse).with(torrent_file)
      torrent = BitTorrentClient.start(torrent_file)
    end

    xit "creates the metainfo" do
      metainfo_hash = double("metainfo_hash")
      MetainfoParser.stub(:parse) { metainfo_hash }

      Metainfo.should_receive(:new).with(metainfo_hash)
      torrent = BitTorrentClient.start(torrent_file)
    end
  end
end
