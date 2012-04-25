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
      client.identify.must_be_instance_of Hash
    end
    
  end
end
