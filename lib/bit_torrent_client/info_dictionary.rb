module BitTorrentClient
  class InfoDictionary
    attr_reader :pieces_string, :piece_length, :name, :filelength, :pieces, :files

    def initialize(args)
      @piece_length = args.fetch("piece length")
      @name = args.fetch("name")
      @pieces_string = args.fetch("pieces")
      @pieces = create_pieces(@pieces_string)
      @files = create_files(args)
    end

    def download_size
      @files.inject(0) { |bytes, file| bytes + file.byte_size }
    end


    private

    def create_pieces(pieces_string)
      collection = PieceCollection.new
      split_by_twenty_bits(pieces_string).each_with_index do |twenty_bit_sha, index|
        collection << Piece.new(index, twenty_bit_sha, @piece_length)
      end
      collection
    end

    def split_by_twenty_bits(string)
      string.scan(/.{20}/)
    end

    def create_files(args)
      if args.has_key?('files')
        offset = 0
        args['files'].map do |file|
          name = file['path'].last
          directories = file['path'].take(file['path'].size - 1)
          file['start_offset'] = offset
          offset += file['length']
          DownloadableFile.new("byte_size" => file['length'], "filename" => name, "directories" => directories, "start_offset" => file['start_offset'])
        end
      else
        [ DownloadableFile.new("byte_size" => args['length'], "filename" => @name) ]
      end
    end
  end
end
