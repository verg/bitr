require_relative "../../../lib/bit_torrent_client/metainfo_parser"
require_relative "../../../lib/bit_torrent_client/metainfo"

module BitTorrentClient
  describe MetainfoParser do
    let(:single_file_torrent) { File.read("spec/fixtures/flagfromserver.torrent") }
    let(:torrent_file_string) { "spec/fixtures/flagfromserver.torrent" }
    let(:multifile_torrent) { File.read("spec/fixtures/python.torrent") }

    it "parses single file torrents" do
      parsed_file = MetainfoParser.parse(single_file_torrent)
      expect(parsed_file['announce']).to eq 'http://thomasballinger.com:6969/announce'
    end

    it "parses multifile torrents" do
      parsed_file = MetainfoParser.parse(multifile_torrent)
      expect(parsed_file['announce']).to eq 'http://tracker001.legaltorrents.com:7070/announce'
    end

    it "can parse a torrent string" do
      parsed_file = MetainfoParser.parse(torrent_file_string)
      expect(parsed_file['announce']).to eq 'http://thomasballinger.com:6969/announce'
    end
    it "can parse a torrent file"
  end
end
