module BitTorrentClient
  class FileWriter

    def initialize(info_dictionary)
      @info_dictionary = info_dictionary
    end

    def write_empty_files
      @info_dictionary.files.each do |file|
        File.open(file.filename, 'w') do |f|
          file.byte_size.times { f.write "\x00"}
        end
      end
    end
  end
end
