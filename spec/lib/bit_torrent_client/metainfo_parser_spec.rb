require_relative "../../../lib/bit_torrent_client/metainfo_parser"
require_relative "../../../lib/bit_torrent_client/metainfo"

module BitTorrentClient
  describe MetainfoParser do
    let(:torrent) { File.read("spec/fixtures/flagfromserver.torrent") }

    it "sends the torrent file to the parser" do
      MetainfoParser.parse(torrent)
    end
  end
end
