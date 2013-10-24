module BitTorrentClient
  module MessageBuilder
    def self.build(message_type, opts={})
      raw_message = build_raw(message_type, opts)
      Message.new(raw_message)
    end

    def self.build_raw(message_type, opts={})
      @opts = opts
      self.send(message_type)
    end

    private

    def self.interested
      "\x00\x00\x00\x01\x02"
    end

    def self.keep_alive
      "\x00\x00\x00\x00"
    end

    def self.handshake
      {
        pstrlen:    "\x13",
        pstr:       "BitTorrent protocol",
        reserved:   "\x00\x00\x00\x00\x00\x00\x00\x00",
        info_hash:  @opts.fetch(:info_hash),
        peer_id:    @opts.fetch(:client_id)
      }.values.join("")
    end

    def self.request
      {
        message_lenth: "\x00\x00\x00\x0d",
        id: "\x06",
        index: @opts.fetch(:index),
        begin: @opts.fetch(:begin),
        length: @opts.fetch(:length)
      }.values.join("")
    end
  end
end
