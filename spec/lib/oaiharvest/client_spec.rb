require_relative '../../spec_helper'
# For Ruby < 1.9.3, use this instead of require_relative
# require (File.expand_path('./../../../spec_helper', __FILE__))

describe Oaiharvest::Client do
  
  it "must include httparty methods" do
    Oaiharvest::Client.must_include HTTParty
  end
  
  it "must have the base url set to an oai endpoint" do
    Oaiharvest::Client.base_uri.must_equal 'http://collections.walkerart.org/oai'
  end 

  describe "GET verb=Identify" do
    let(:client) { Oaiharvest::Client.new }
    
    before do
    VCR.insert_cassette 'client', :record => :new_episodes
    end
    
    after do
      VCR.eject_cassette
    end

    it "has a harvest method" do 
      client.must_respond_to :harvest
    end

    it "it identifies a target" do
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

end
