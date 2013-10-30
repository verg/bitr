module BitTorrentClient
  class FileWriter

    attr_reader :files
    def initialize(info_dictionary)
      @info_dictionary = info_dictionary
      @files = @info_dictionary.files
    end

    def write_empty_files
      @info_dictionary.files.each do |file|
        make_dirs(file.directories) if file.directories.any?

        File.open(file.full_path, 'w') do |f|
          empty_bytes = "\x00" * file.byte_size
          f.write empty_bytes
        end
      end
    end

    def files_to_write(byte_range)
      @files.select { |file| file.byte_overlap?(byte_range) }
    end

    private

    def make_dirs(directories)
      (0..directories.size).each do |depth|
        dir = directories[0..depth].join('/')
        Dir.mkdir(dir) unless Dir.exists?(dir)
      end
    end
  end
end
