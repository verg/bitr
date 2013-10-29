module BitTorrentClient
  class DownloadController
    attr_reader :sockets, :pieces
    def initialize(pieces)
      @sockets = []
      @pieces = pieces
    end

    def add_socket(socket)
      @sockets << socket

      tick
    end

    def tick

    end

    def send_request(socket)
      piece = next_piece
      socket.request_piece(piece.index,
                           piece.next_byte_offset,
                           BitTorrentClient.hex_block_bytes)
    end

    def remove_socket(socket)
      @sockets.delete(socket)
    end

    def pending_requests
      0
    end

    def next_piece
      pieces.incomplete.first
    end

  end
end
