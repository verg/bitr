require_relative "../../../lib/bit_torrent_client/announce_response"

describe AnnounceResponse do
  let(:response_body) { "d8:completei0e10:downloadedi0e10:incompletei1e8:intervali1744e12:min intervali872e5:peers6:J\xD4\xB7\xBA\x1A\xE1e" }

  it "knows the number of seeders" do
    response = AnnounceResponse.new(response_body)
    expect(response.seeders).to eq 0
  end

  it "knows the number of leachers" do
    response = AnnounceResponse.new(response_body)
    expect(response.leachers).to eq 1
  end

  describe "#peers" do
    it "returns an array of hashes with ip and port for each peer" do
      response = AnnounceResponse.new(response_body)
      expect(response.peers).to eq [{:ip=>"74.212.183.186", :port=>6881}]
    end
  end

  describe "response interval" do
    it "has a time interval to wait for subsequent requests" do
      response = AnnounceResponse.new(response_body)
      expect(response.interval).to eq 1744
    end
  end
end
