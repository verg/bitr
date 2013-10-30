require_relative "../../../lib/bit_torrent_client/downloadable_file"

module BitTorrentClient
  describe DownloadableFile do

    let(:single_file) { {"filename" => "flag.jpg", "byte_size" => 1277987} }

    let(:multi_file) { { "filename" => "python-2.6.2.msi", "directories" => ["lib", "content"], "byte_size" => 4536192 } }

    it "has a filename" do
      file = DownloadableFile.new(single_file)
      expect(file.filename).to eq "flag.jpg"
    end

    it "has the length of the file in bytes" do
      file = DownloadableFile.new(single_file)
      expect(file.byte_size).to eq 1277987
    end

    it "has a start_offset reflecting # of bytes from beginning of torrent" do
      files = [single_file, multi_file]
      offset = 0
      files.map! do |file|
        file['start_offset'] = offset
        offset += file['byte_size']
        DownloadableFile.new(file)
      end
      expect(files.first.start_offset).to eq 0
      expect(files.last.start_offset).to eq single_file['byte_size']
    end

    it "has a byte range relative to the full torrent download" do
      files = [single_file, multi_file]
      offset = 0
      files.map! do |file|
        file['start_offset'] = offset
        offset += file['byte_size']
        DownloadableFile.new(file)
      end
      expect(files.first.byte_range).to eq 0...single_file['byte_size']
      expect(files.last.byte_range).to eq single_file['byte_size']...(single_file['byte_size'] + multi_file['byte_size'])
    end

    describe "#directories" do
      it "knows the directories the file lives in" do
        file = DownloadableFile.new(multi_file)
        expect(file.directories).to eq ["lib", "content"]
      end

      it "returns an empty array if the file is not in a dir" do
        file = DownloadableFile.new(single_file)
        expect(file.directories).to eq []
      end
    end

    describe "#full_path" do
      it "returns a full path for files in nested directories" do
        file = DownloadableFile.new(multi_file)
        expect(file.full_path).to eq "lib/content/python-2.6.2.msi"
      end

      it "returns the filename for files not in directories" do
        file = DownloadableFile.new(single_file)
        expect(file.full_path).to eq single_file['filename']
      end
    end

    it "determines if an abosulte byte offsite is within the file" do
      file = DownloadableFile.new(single_file)

      overlaps_with_start = -1..0
      overlaps_with_end = (file.byte_size - 1)..file.byte_size
      within_file_range = 10..11
      encompases_file = -1..file.byte_size
      outside_range = file.byte_size..(file.byte_size + 1)

      expect(file.byte_overlap?(overlaps_with_start)).to be_true
      expect(file.byte_overlap?(overlaps_with_end)).to be_true
      expect(file.byte_overlap?(within_file_range)).to be_true
      expect(file.byte_overlap?(encompases_file)).to be_true

      expect(file.byte_overlap?(outside_range)).to be_false
    end
  end
end
