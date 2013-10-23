require 'net/http'

module BitTorrentClient
  class HTTPClient
    def initialize(peer_id, opts={})
      @peer_id = peer_id
      @port = opts.fetch(:port) { 6881 }
      @compact = opts.fetch(:compact) { true }
    end

    def get_start_event(torrent)
      request_params = build_request_params(torrent)

      uri = URI(torrent.announce_url)
      uri.query = URI.encode_www_form(request_params)
      response = Net::HTTP.get_response(uri)
      AnnounceResponse.new(response.body)
    end

    private

    def build_request_params(torrent)
      if @compact
        compact_param = { 'compact' => 1 }
      else
        compact_param = { 'compact' => 0 }
      end

      { 'info_hash' => torrent.info_hash,
        'peer_id' => @peer_id,
        'port' => @port,
        'uploaded' => torrent.uploaded_bytes,
        'downloaded' => torrent.downloaded_bytes,
        'left' => torrent.bytes_left,
        'no_peer_id' => 0,
        'event' => "started" }.merge(compact_param)
    end
  end
end
