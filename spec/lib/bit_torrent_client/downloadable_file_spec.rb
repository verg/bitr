require_relative "../../../lib/bit_torrent_client/downloadable_file"

module BitTorrentClient
  describe DownloadableFile do
    it "has a filename" do
      file = DownloadableFile.new("flag.jpg", 1277987)
      expect(file.filename).to eq "flag.jpg"
    end

    it "has the length of the file in bytes" do
      file = DownloadableFile.new("flag.jpg", 1277987)
      expect(file.byte_size).to eq 1277987
    end

    describe "#directories" do
      it "knows the directories the file lives in" do
        file = DownloadableFile.new( "python-2.6.2.msi", ["lib", "content"], 4536192)
        expect(file.directories).to eq ["lib", "content"]
      end

      it "returns an empty array if the file is not in a dir" do
        file = DownloadableFile.new("flag.jpg", 1277987)
        expect(file.directories).to eq []
      end
    end

    describe "#full_path" do
      it "returns a full path for files in nested directories" do
        file = DownloadableFile.new( "python-2.6.2.msi", ["lib", "content"], 4536192)
        expect(file.full_path).to eq "lib/content/python-2.6.2.msi"
      end

      it "returns the filename for files not in directories" do
        file = DownloadableFile.new("flag.jpg", 1277987)
        expect(file.directories).to eq []
      end
    end
  end
end
