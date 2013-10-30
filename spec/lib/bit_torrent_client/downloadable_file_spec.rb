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
  end
end
