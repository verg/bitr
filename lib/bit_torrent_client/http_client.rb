require 'net/http'

module BitTorrentClient
  class HTTPClient
    def initialize(peer_id, opts={})
      @peer_id = peer_id
      @port = opts.fetch(:port) { 6881 }
      @compact = opts.fetch(:compact) { true }
    end

    def get_start_event(metainfo)
      if @compact
        compact_param = { 'compact' => 1 }
      else
        compact_param = { 'compact' => 0 }
      end

      request_params = { 'info_hash' => metainfo.info_hash,
                         'peer_id' => @peer_id,
                         'port' => @port,
                         'uploaded' => metainfo.uploaded_bytes,
                         'downloaded' => metainfo.downloaded_bytes,
                         'left' => metainfo.bytes_left,
                         'no_peer_id' => 0,
                         'event' => "started" }.merge(compact_param)

      uri = URI(metainfo.announce)
      uri.query = URI.encode_www_form(request_params)
      response = Net::HTTP.get_response(uri)
    end
  end
end
