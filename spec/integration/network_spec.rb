# encoding: UTF-8
require_relative "../../lib/bit_torrent_client"
require_relative "../vcr_helper"
require 'vcr'

module BitTorrentClient
  describe 'Network' do

    it "shakes hands with a peer" do
      torrent_file = File.read("spec/fixtures/flagfromserver.torrent")
      metainfo = Metainfo.new(MetainfoParser.parse(torrent_file))
      peer_id = "-RV0001-000000000002"

      metainfo.stub(:uploaded_bytes) { 0 }
      metainfo.stub(:downloaded_bytes) { 0 }
      metainfo.stub(:bytes_left) { 16384 }

      response = HTTPClient.new(peer_id).get_start_event(metainfo)
      peers = response.peers
      peers.map! { |peer| Peer.new(peer) }
      THE_RIGHT_PEER = peers.select { |peer| peer.ip == "96.126.104.219" }.first
      socket = TCPClient.new(THE_RIGHT_PEER, peer_id, metainfo.info_hash)
      data = socket.exchange_handshake
      expect(handle_encoding(data)).to match(/BitTorrent protocol/)
      socket.shutdown
    end

    it "sends an interested message and receives an unchoke response" do
      torrent_file = File.read("spec/fixtures/flagfromserver.torrent")
      metainfo = Metainfo.new(MetainfoParser.parse(torrent_file))
      peer_id = "-RV0001-000000000002"

      metainfo.stub(:uploaded_bytes) { 0 }
      metainfo.stub(:downloaded_bytes) { 0 }
      metainfo.stub(:bytes_left) { 16384 }

      response = HTTPClient.new(peer_id).get_start_event(metainfo)
      peers = response.peers
      peers.map! { |peer| Peer.new(peer) }
      THE_RIGHT_PEER = peers.select { |peer| peer.ip == "96.126.104.219" }.first
      socket = TCPClient.new(THE_RIGHT_PEER, peer_id, metainfo.info_hash)
      socket.exchange_handshake
      data = socket.declare_interest
      messages = MessageHandler.new.handle(data)
      expect(messages.first.type).to eq :unchoke

      socket.shutdown
    end

    def handle_encoding(string)
      string.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
    end
  end
end
