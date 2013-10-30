require_relative "../../../lib/bit_torrent_client/file_writer"
require_relative "../../../lib/bit_torrent_client/downloadable_file"

module BitTorrentClient
  describe FileWriter do
    let(:first_file) { {"filename" => "first_file", "byte_size" => 4} }
    let(:other_file) { { "filename" => "other_file", "byte_size" => 5 } }

    describe "#write_empty_files" do
      it "writes a single empty file" do
        file = DownloadableFile.new(first_file)
        info_dictionary = double("info_dictionary", files: [file].flatten)
        writer = FileWriter.new(info_dictionary)

        writer.write_empty_files

        empty_file = File.read(first_file['filename'])
        expect(empty_file).to eq "\x00\x00\x00\x00"
        expect(empty_file.size).to eq 4

        `rm #{first_file['filename']}`
      end

      it "writes multiple empty files" do
        files = [DownloadableFile.new(first_file), DownloadableFile.new(other_file)]
        info_dictionary = double("info_dictionary", files: [files].flatten)
        writer = FileWriter.new(info_dictionary)

        writer.write_empty_files

        file_1 = File.read(first_file['filename'])
        file_2 = File.read(other_file['filename'])

        expect(file_1).to eq "\x00\x00\x00\x00"
        expect(file_2).to eq "\x00\x00\x00\x00\x00"
        expect(file_1.size).to eq 4
        expect(file_2.size).to eq 5

        `rm #{first_file['filename']} #{other_file['filename']}`
      end

      it "creates new directories" do
        file_with_dir = { "filename" => "file", "directories" => ["folder", "content"], "byte_size" => 4 }

        file_with_same_dirs = { "filename" => "file_1", "directories" => ["folder", "content"], "byte_size" => 4536192 }

        file = [DownloadableFile.new(file_with_dir), DownloadableFile.new(file_with_same_dirs)]
        info_dictionary = double("info_dictionary", files: [file].flatten)
        writer = FileWriter.new(info_dictionary)

        writer.write_empty_files

        expect(Dir.exists?("folder")).to be_true
        expect(Dir.exists?("folder/content")).to be_true
        empty_file = File.read(file.first.full_path)
        expect(empty_file).to eq "\x00\x00\x00\x00"
        expect(empty_file.size).to eq 4

        `rm -r #{file.first.full_path}`
      end
    end
  end
end
