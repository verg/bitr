module BitTorrentClient
  class DownloadController
    attr_reader :sockets, :pieces, :pending_requests
    def initialize(pieces)
      @sockets = []
      @pieces = pieces
      @pending_requests = 0
    end

    def add_socket(socket)
      @sockets << socket
    end

    def tick
      send_request while ready?
    end

    def handle_piece_message(piece)
      piece_received
    end

    def ready?
      has_sockets? && !download_complete? && !requests_maxed?
    end

    def send_request
      piece = next_piece
      socket = first_available_peer(piece.index)
      socket.request_piece(piece.index,
                           piece.next_byte_offset,
                           BitTorrentClient.hex_block_bytes)
      piece_requested
      piece.block_requested!(piece.next_byte_offset)
    end

    def first_available_peer(piece_index)
      @sockets.find { |socket| socket.peer.has_piece? piece_index }
    end

    def piece_requested
      @pending_requests += 1
    end

    def piece_received
      raise IndexError if @pending_requests < 1
      @pending_requests -= 1
    end

    def requests_maxed?
      @pending_requests >= BitTorrentClient::MAX_CONNECTIONS
    end

    def remove_socket(socket)
      @sockets.delete(socket)
    end

    def has_sockets?
      sockets.length > 0
    end

    def download_complete?
      @pieces.download_complete?
    end

    def next_piece
      pieces.incomplete.find { |piece| piece.has_incomplete_blocks? }
    end
  end
end
