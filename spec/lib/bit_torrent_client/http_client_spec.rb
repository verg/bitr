require_relative "../../../lib/bit_torrent_client"
require_relative "../../vcr_helper"
require 'vcr'

module BitTorrentClient
  describe HTTPClient do
    describe "#get_start_event" do
      it "creates a url" do
        VCR.use_cassette("get_torrent_start_event") do
          torrent_file = File.read("spec/fixtures/flagfromserver.torrent")
          torrent = Torrent.new(torrent_file)
          torrent.stub(:my_peer_id) { "-RV0001-000000000002" }

          response= HTTPClient.new(torrent.my_peer_id).get_start_event(torrent)
          expect(response).to be_instance_of AnnounceResponse
        end
      end

      it "handles bad requests"

      describe "uploaded and downloaded stats" do
        it "sends the number of bytes downloaded since the client sent the 'started' event"
        it "sends the number of bytes uploaded since the client sent the 'started' event"
      end

      describe "'event' parameter" do
        it "sends a status of 'started' for the first request to the tracker"
        it "doesn't send the 'completed' status when starting a connection at 100% downloaded"
      end

      describe "#get_completed_event" do
        it "sends the status of 'completed' when a download reaches 100%"
      end

      describe "#get_stop_event" do
        it "sends the status of 'stopped' when the client shuts down"
      end
    end
  end
end

