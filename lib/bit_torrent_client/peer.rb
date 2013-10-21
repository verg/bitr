module BitTorrentClient
  class Peer
    attr_reader :ip, :port
    attr_accessor :choking, :interested
    alias_method :choking?, :choking
    alias_method :interested?, :interested

    def initialize(args)
      @ip = args.fetch(:ip)
      @port = args.fetch(:port)
      @choking = true
      @interested = false
    end
  end
end
