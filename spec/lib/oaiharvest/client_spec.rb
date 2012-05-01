require_relative '../../spec_helper'

describe Oaiharvest::Client do
  
  it "must include httparty methods" do
    Oaiharvest::Client.must_include HTTParty
  end
  
  it "starts with empty base url" do
    Oaiharvest::Client.base_uri.must_be_nil
  end 

  describe "verbs" do
    
    before do
      @options = {:base_uri => 'collections.walkerart.org:8083/oai'}
      VCR.insert_cassette 'client', :record => :new_episodes
    end
    
    after do
      VCR.eject_cassette
    end
    let(:client) { Oaiharvest::Client.new @options }

    it "requires metadata_prefix " do 
      lambda{client.list_records}.must_raise(RuntimeError,"metadata_prefix required")        
    end

    it "forms a valid query" do
      client.make_query.must_equal({})
      client.make_query({:metadata_prefix=>"oai_dc"}).must_equal({'metadataPrefix' => "oai_dc"})
    end

    it "reports an error" do 
      listed_records = client.list_records( {:metadata_prefix => "cdwalite"} )
      listed_records[0].must_match /.*results in an empty list.*/
    end

    it "ListRecords: with cdwalite" do
      listed_records = client.list_records( {:metadata_prefix => "cdwalite", :set => 'object'} )
      listed_records[0].metadata["title"].must_equal("Lyric Suite")
      # record info is to deep;
      # this information is in the header anyway
      listed_records[0].metadata["record"].must_be_nil
    end

    it "ListRecords: with dublin core" do 
      listed_records = client.list_records( {:metadata_prefix => "oai_dc"} )
      listed_records[0].must_respond_to :header
      listed_records[0].must_respond_to :metadata
      listed_records[0].header.must_include("identifier")
      listed_records[0].metadata.must_include("identifier")
    end

    it "ListMetadataFormats: returns list of formats" do 
      listed_formats = client.list_metadata_formats
      listed_formats.must_be_instance_of Array
      listed_formats[0].must_be_instance_of Hash
      listed_formats[0].must_include "metadata_prefix"
      listed_formats[0]["metadata_prefix"].must_equal "oai_dc"
    end

    it "ListIdentifiers: returns headers " do 
      listed_identifiers = client.list_identifiers
      listed_identifiers.must_be_instance_of Array
      listed_identifiers[0].must_be_instance_of Hash
      listed_identifiers[0].must_include(  "identifier" )
      listed_identifiers[0]["identifier"].must_equal "oai:walkerart.org/object/1"
    end

    it "ListSets: returns an Array of sets " do 
      listed_sets = client.list_sets
      listed_sets.must_be_instance_of Array
      listed_sets.must_equal ["object", "text", "sound", "video", "sia", "artfinder"]
    end

    it "Identify: it identifies a target" do
      identified = client.identify
      identified.must_be_instance_of Hash
      identified[:repository_name].must_equal "Walker Art Center Collection Metadata"
      identified[:base_url].must_equal "http://prop.walkerart.org:8080/mason/oai/index.html"
      identified[:protocol_version].must_equal "2.0"
      identified[:earliest_datestamp].must_equal "2002-02-15"
      identified[:deleted_record].must_equal "persistent"
      identified[:granularity].must_equal "YYYY-MM-DD"
    end
  end



  describe "Client options" do 
    before do 
      options = {:base_uri => 'collections.walkerart.org:8083/oai'}
      @set_options = options.merge({:set => 'objects'})
    end

    let(:client) { Oaiharvest::Client.new @set_options}
    
    it "sets set" do
      client.opts[:set].must_equal 'objects'
    end

    it "base_uri setter is private" do 
      client.wont_respond_to :base_uri=
      client.class.wont_respond_to :base_uri=
      client.class.base_uri.must_equal 'http://collections.walkerart.org:8083/oai'
    end

    it "can change base_uri on the fly" do 
      client.class.must_respond_to :base_uri
      old_uri = client.class.base_uri
      client.class.base_uri 'test'
      client.class.base_uri.must_equal 'http://test'
      client.class.base_uri old_uri      
    end

  end

end
