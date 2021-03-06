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

    def handle_piece_message(piece_message, file_writer, file_reader)
      raise IndexError if @pending_requests < 1

      piece = @pieces.find(piece_message.piece_index)
      block = piece.find_block(piece_message.byte_offset)
      block.complete!

      file_writer.write(piece_message.block, block.byte_range)

      piece.verify(file_reader) if piece.complete?

      @pending_requests -= 1
    end

    def ready?
      has_sockets? && !download_complete? && !requests_maxed? && !next_piece.nil?
    end

    def send_request
      piece = next_piece
      block = piece.next_block
      socket = first_available_peer(piece.index)
      socket.request_piece(piece.index,
                           # TODO extract this packing
                           [block.byte_offset].pack("N*"),
                           BitTorrentClient.hex_block_bytes)
      piece_requested
      block.requested!
    end

    def first_available_peer(piece_index)
      @sockets.find { |socket| socket.peer.has_piece? piece_index }
    end

    def piece_requested
      @pending_requests += 1
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
      possible_pieces = pieces.incomplete.select { |piece| piece.has_incomplete_blocks? }
      possible_pieces.sample
    end
  end
end
