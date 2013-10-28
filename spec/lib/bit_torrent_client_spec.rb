require_relative "../../lib/bit_torrent_client"
require_relative "../../lib/bit_torrent_client/metainfo_parser"

module BitTorrentClient
  describe BitTorrentClient do
    let(:torrent_file) {"spec/fixtures/flagfromserver.torrent"}
    it "initializes with a torrent file" do
      EM.run do
        torrent = BitTorrentClient.start(torrent_file, {print_log: true})
        expect(torrent.torrent_file).to eq(torrent_file)

        expect(torrent.uploaded_bytes).to eq(0)
        expect(torrent.downloaded_bytes).to eq(0)
        expect(torrent.bytes_left).to eq 1277987
        expect(torrent.peers).to_not be_empty
        EM::Timer.new(2) do
          expect(torrent.pieces.complete.length).to be > 0
          expect(torrent.pieces.incomplete.length).to be > 0
          EM.stop
        end
      end
    end

    it "generates a random client id" do
      expect(BitTorrentClient::MY_PEER_ID).to include("-RV0001-")
    end

    describe Torrent do
      it "knows the announce url" do
        torrent = Torrent.new(torrent_file)
        expect(torrent.announce_url).to eq 'http://thomasballinger.com:6969/announce'
      end

      it "knows the info hash" do
        info_hash = double("metainfo_hash")
        Metainfo.any_instance.stub(:info_hash) { info_hash }

        torrent = Torrent.new(torrent_file)
        expect(torrent.info_hash).to eq info_hash
      end

      it "has a collection of pieces" do
        pieces = double("pieces_collection")
        Metainfo.any_instance.stub(:pieces) { pieces }
        torrent = Torrent.new(torrent_file)
        expect(torrent.pieces).to eq pieces
      end

      it "has a peer id" do
        torrent = Torrent.new(torrent_file)
        expect(torrent.my_peer_id).to eq BitTorrentClient::MY_PEER_ID
      end

      it "has a port" do
        torrent = Torrent.new(torrent_file)
        expect(torrent.my_port).to eq BitTorrentClient::MY_PORT
      end

      it "knows the length of pieces" do
        torrent = Torrent.new(torrent_file)
        expect(torrent.piece_length).to eq 16384
      end
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
