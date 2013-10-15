require_relative "../../../lib/bit_torrent_client/metainfo"
require_relative "../../../lib/bit_torrent_client/info_dictionary"
require_relative "../../../lib/bit_torrent_client/piece"
require_relative "../../../lib/bit_torrent_client/downloadable_file"

module BitTorrentClient
  describe Metainfo do
    let(:pieces) { "\x12\x34\x56\x78\x9a\xbc\xde\xf1\x23\x45\x67\x89\xab\xcd\xef\x12\x34\x56\x78\x9a".encode('UTF-8', 'binary', invalid: :replace, undef: :replace)}

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

    it "creates an InfoDictonary with the file information" do
      InfoDictionary.should_receive(:new).with( {"length"=>1277987,
                                                "name"=>"flag.jpg",
                                                "piece length"=>16384,
                                                "pieces"=> pieces } )
      Metainfo.new(metainfo_hash)
    end

    it "stores an info hash as a SHA1 of the value of the bencoded info key" do
      metainfo = Metainfo.new(metainfo_hash)
      expect(metainfo.info_hash.size).to eq 20
    end

    it "has pieces through it's info dictionary" do
      metainfo = Metainfo.new(metainfo_hash)
      expect(metainfo.pieces.size).to eq 1
    end

    it "knows the amount of bytes uploaded"
    it "knows the amount of bytes downloaded"
  end
end
