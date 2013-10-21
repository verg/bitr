require 'bencode'
require 'ipaddr'

module BitTorrentClient
  class AnnounceResponse
    attr_reader :response_body, :seeders, :leachers, :interval, :peers

    def initialize(response_body)
      @response_body = response_body
      @seeders = parsed_response_body.fetch("complete")
      @leachers = parsed_response_body.fetch("incomplete")
      @interval = parsed_response_body.fetch("interval")
      @peers = get_peers
    end

    private

    def parsed_response_body
      @parsed ||= BEncode.load(@response_body)
    end

    def get_peers
      decode_peers.map! do |peer|
        ip_bytes, port = peer.unpack("a4n")
        { ip: IPAddr.new_ntoh(ip_bytes).to_s, port: port }
      end
    end

    def decode_peers
      BEncode.load(@response_body)['peers'].scan(/.{6}/)
    end
  end
end
