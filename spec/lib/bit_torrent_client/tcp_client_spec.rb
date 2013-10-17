require_relative "../../../lib/bit_torrent_client"

describe TCPClient do

  #let(:info_hash) { "%2b%15%ca%2b%fdH%cd%d7m9%ecU%a3%ab%1b%8aW%18%0a%09" }
  #let(:peer) { Peer.new({:ip=>"74.212.183.186", :port=>6881}) }
  #torrent_file = File.read("spec/fixtures/flagfromserver.torrent")
  #info_hash = Metainfo.new(MetainfoParser.parse(torrent_file)).info_hash
  #let(:tcp_client) { TCPClient.new(peer, "-RV0001-000000000002", info_hash) }
  xit "has a handshake" do
    torrent_file = File.read("spec/fixtures/flagfromserver.torrent")
    message = tcp_client.handshake_message
    expect(message).to eq "\\x13BitTorrent protocol\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00%E5%8F%CA%C55%AB%13H-%96%C1W%FA1%1A3/k%FA%86-RV0001-000000000002"
  end

  xit "shakes hands with the client" do
    response = tcp_client.send_handshake
    expect(response).to eq ''
  end

end
