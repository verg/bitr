module BitTorrentClient
  class FileWriter

    def initialize(info_dictionary)
      @info_dictionary = info_dictionary
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

    private

    def make_dirs(directories)
      (0..directories.size).each do |depth|
        dir = directories[0..depth].join('/')
        Dir.mkdir(dir) unless Dir.exists?(dir)
      end
    end
  end
end
