require_relative "../../../lib/bit_torrent_client/file_reader"
require_relative "../../../lib/bit_torrent_client/downloadable_file"

module BitTorrentClient
  describe FileReader do
    let(:first_file) { {"filename" => "first_file", "byte_size" => 4,
                        "start_offset" => 0} }
    let(:other_file) { { "filename" => "other_file", "byte_size" => 5,
                         "start_offset" => 4} }

    it "knows of some files" do
      file = DownloadableFile.new(first_file)
      info_dictionary = double("info_dictionary", files: [file].flatten)
      reader = FileReader.new(info_dictionary)
      expect(reader.files).to eq [file]
    end


    describe "reads specific bytes within a file" do
      it "identifies files that contain the specified bytes" do
        byte_range = 8..9
        file_with_bytes = double("file", byte_overlap?: true)
        file_outside_of_bytes = double("file", byte_overlap?: false)
        info_dictionary = double("info_dictionary",
                                 files: [file_with_bytes, file_outside_of_bytes])

        reader = FileReader.new(info_dictionary)
        expect(reader.files_to_read(byte_range)).to eq [file_with_bytes]
      end

      context "when reading from a single file" do
        it "reads data from the correct range" do
          File.open(first_file['filename'], "w") do |f|
            f.write("\x00\x01\x02\x03")
          end

          file = DownloadableFile.new(first_file)
          info_dictionary = double("info_dictionary", files: [file].flatten)
          reader = FileReader.new(info_dictionary)

          byte_range = 0...4
          read_data = reader.read(byte_range)

          expect(read_data).to eq "\x00\x01\x02\x03"
          expect(read_data.length).to eq 4

          `rm #{first_file['filename']}`
        end
      end

      context "when reading from multiple files" do
        it "reads data from the correct file" do
          File.open(first_file['filename'], "w") do |f|
            f.write("\x00\x01\x02\x03")
          end
          File.open(other_file['filename'], "w") do |f|
            f.write("\x04\x05\x06\x07\x08")
          end

          files = [DownloadableFile.new(first_file), DownloadableFile.new(other_file)]
          info_dictionary = double("info_dictionary", files: [files].flatten)
          reader = FileReader.new(info_dictionary)

          byte_range = 3...6
          read_data = reader.read(byte_range)

          expect(read_data).to eq "\x03\x04\x05"
          expect(read_data.length).to eq 3

          `rm #{first_file['filename']}`
          `rm #{other_file['filename']}`
        end
      end
    end
  end
end
