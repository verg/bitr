require_relative "../../../lib/bit_torrent_client/metainfo_parser"
require_relative "../../../lib/bit_torrent_client/metainfo"

module BitTorrentClient
  describe MetainfoParser do
    let(:single_file_torrent) { File.read("spec/fixtures/flagfromserver.torrent") }
    let(:multifile_torrent) { File.read("spec/fixtures/python.torrent") }

    it "parses single file torrents" do
      MetainfoParser.parse(single_file_torrent)
    end

    it "parses multifile torrents" do
      MetainfoParser.parse(multifile_torrent)
    end
  end
end
