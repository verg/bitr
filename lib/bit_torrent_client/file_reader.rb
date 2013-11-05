module BitTorrentClient
  class FileReader

    attr_reader :files
    def initialize(info_dictionary)
      @info_dictionary = info_dictionary
      @files = @info_dictionary.files
    end

    def files_to_read(byte_range)
      @files.select { |file| file.byte_overlap?(byte_range) }
    end

    def read(byte_range)
      bytes = ''
      files_to_read(byte_range).each do |file|
        seek_point = file.find_seek_point(byte_range.begin)
        bytes_to_read = byte_range.end - file.start_offset
        File.open(file.full_path, "r") do |f|
          f.seek(seek_point)
          bytes << f.read(bytes_to_read)
        end
      end
      bytes
    end
  end
end
