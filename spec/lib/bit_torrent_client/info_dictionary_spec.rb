require_relative "../../../lib/bit_torrent_client/info_dictionary"
require_relative "../../../lib/bit_torrent_client/downloadable_file"
require_relative "../../../lib/bit_torrent_client/piece"
require_relative "../../../lib/bit_torrent_client/piece_collection"
require_relative "../../../lib/bit_torrent_client/config"

module BitTorrentClient
  describe InfoDictionary do
    let(:pieces) { "e\x96\xDD\xEEGt\xDE{\xCF-\xD3\xD9\x03\x9C\xC3\xDA\xA7\xA9Y\x87\xCFw\xD9\x18\xBBA\xCD1\xA7\xED\xA5\xEC\x01U\x86\xC0\xCD\xF1\xEF\xEC".encode('UTF-8', 'binary', invalid: :replace, undef: :replace)}

    let(:info_hash) { { "length"=>1277987, "name"=>"flag.jpg",
                        "piece length"=>16384, "pieces"=> pieces } }

    it "knows the number of bytes in each piece" do
      info_dict = InfoDictionary.new(info_hash)
      expect(info_dict.piece_length).to eq 16384
    end

    it "knows the full pieces string" do
      info_dict = InfoDictionary.new(info_hash)
      expect(info_dict.pieces_string).to eq pieces
    end

    describe "pieces" do
      it "breaks the pieces string into 20 char shas" do
        info_dict = InfoDictionary.new(info_hash)
        expect(info_dict.pieces.first.sha).to eq pieces[0...20]
        expect(info_dict.pieces.last.sha).to eq pieces[20...40]
      end
    end

    context "single file torrents" do
      it "has the torrent's name" do
        info_dict = InfoDictionary.new(info_hash)
        expect(info_dict.name).to eq "flag.jpg"
      end

      it "creates a file" do
        DownloadableFile.should_receive(:new).with("filename" => "flag.jpg",
                                                   "byte_size" => 1277987)
        InfoDictionary.new(info_hash)
      end
    end

    context "multi-file torrents" do
    let(:info_hash) { { "length"=>1277987, "name"=>"flag.jpg",
                        "piece length"=>16384, "pieces"=> pieces } }

      let(:info_hash) { {"files"=>
                         [{"length"=>14536192, "path"=>["content", "flag.jpg"]},
                          {"length"=>56, "path"=>["license.txt"]}],
                         "name"=>"ipatrol - Python 2_6_2",
                         "piece length"=>32768,
                         "pieces"=> pieces } }

      it "has the name of the file path of the dir which stores the files" do
        info_dict = InfoDictionary.new(info_hash)
        expect(info_dict.name).to eq "ipatrol - Python 2_6_2"
      end

      it "creates a file for each file in the torrent" do
        DownloadableFile.should_receive(:new).once.with({ "byte_size" => 14536192,
                                                        "filename" => "flag.jpg",
                                                        "directories" => ["content"] } )
        DownloadableFile.should_receive(:new).once.with("byte_size" => 56,
                                                        "filename" => "license.txt",
                                                        "directories" => [])
        InfoDictionary.new(info_hash)
      end

      it "holds a list of files" do
        info_dict = InfoDictionary.new(info_hash)
        expect(info_dict.files.count).to eq 2
      end

      it "calculates the total download size" do
        info_dict = InfoDictionary.new(info_hash)
        expect(info_dict.download_size).to eq 14536248
      end
    end
  end
end
