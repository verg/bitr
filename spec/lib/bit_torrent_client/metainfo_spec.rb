require_relative "../../../lib/bit_torrent_client/metainfo"

module BitTorrentClient
  describe Metainfo do
    let(:pieces) { double("pieces") }
    let (:metainfo_hash) { {"announce"=>"http://example.com:6969/announce",
                            "created by"=>"uTorrent/1640",
                            "creation date"=>1350935447,
                            "encoding"=>"UTF-8",
                            "info"=> {"length"=>1277987,
                                      "name"=>"flag.jpg",
                                      "piece length"=>16384,
                                      "pieces"=> pieces }
    }
    }

    it "announces the url of the tracker" do
      metainfo = Metainfo.new(metainfo_hash)
      expect(metainfo.announce).to eq "http://example.com:6969/announce"
    end

    it "optionally lists where it was created" do
      metainfo = Metainfo.new(metainfo_hash)
      expect(metainfo.created_by).to eq "uTorrent/1640"
    end

    it "optionally has a creation date" do
      metainfo = Metainfo.new(metainfo_hash)
      expect(metainfo.creation_date).to eq 1350935447
    end

    it "optionally list the encoding" do
      metainfo = Metainfo.new(metainfo_hash)
      expect(metainfo.encoding).to eq "UTF-8"
    end

    describe "Info Dictionary" do
      it "lists the number of bytes in each piece" do
        metainfo = Metainfo.new(metainfo_hash)
        expect(metainfo.piece_length).to eq 16384
      end

      it "lists the pieces" do
        metainfo = Metainfo.new(metainfo_hash)
        expect(metainfo.pieces).to eq pieces
      end

      context "single file torrents" do
        it "has the torrent's filename" do
          metainfo = Metainfo.new(metainfo_hash)
          expect(metainfo.filename).to eq "flag.jpg"
        end

        it "has the length of the file in bytes" do
          metainfo = Metainfo.new(metainfo_hash)
          expect(metainfo.filelength).to eq 1277987
        end
      end

      #TODO handle torrents with multiple files (don't currently have a ex torrent)
      context "multi-file torrents" do
        it "has the name of the file path of the dir which stores the files"
        it "it has a list of dictionaries for each file"
        context "file dictionaries" do
          it "has the length of the file"
          it "holds the path of the file"
        end
      end
    end
  end
end
