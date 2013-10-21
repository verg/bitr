require_relative "../../lib/bit_torrent_client"
require_relative "../vcr_helper"
require 'vcr'

module BitTorrentClient
  describe 'Network' do
    it "shakes hands with a peer" do
      VCR.use_cassette("get_torrent_start_event") do
        torrent_file = File.read("spec/fixtures/flagfromserver.torrent")
        metainfo = Metainfo.new(MetainfoParser.parse(torrent_file))
        peer_id = "-RV0001-000000000002"

        metainfo.stub(:uploaded_bytes) { 0 }
        metainfo.stub(:downloaded_bytes) { 0 }
        metainfo.stub(:bytes_left) { 16384 }

        response = HTTPClient.new(peer_id).get_start_event(metainfo)
        peers = response.peers
        peers.map! { |peer| Peer.new(peer) }
        socket = TCPClient.new(peers[1], peer_id, URI.encode(metainfo.info_hash))
        data = socket.send_handshake
        expect(data).to eq 'something'
      end
    end
  end
end