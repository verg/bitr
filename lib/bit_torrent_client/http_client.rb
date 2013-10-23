require 'net/http'

module BitTorrentClient
  class HTTPClient
    def initialize(torrent, opts={})
      @torrent = torrent
      @compact = opts.fetch(:compact) { true }
    end

    def get_start_event
      uri = URI(@torrent.announce_url)
      uri.query = URI.encode_www_form(build_request_params)
      response = Net::HTTP.get_response(uri)
      AnnounceResponse.new(response.body)
    end

    private

    def build_request_params
      if @compact
        compact_param = { 'compact' => 1 }
      else
        compact_param = { 'compact' => 0 }
      end

      { 'info_hash' => @torrent.info_hash,
        'peer_id' => @torrent.my_peer_id,
        'port' => @torrent.my_port,
        'uploaded' => @torrent.uploaded_bytes,
        'downloaded' => @torrent.downloaded_bytes,
        'left' => @torrent.bytes_left,
        'no_peer_id' => 0,
        'event' => "started" }.merge(compact_param)
    end
  end
end
