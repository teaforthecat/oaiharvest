require 'nokogiri'
module Oaiharvest
  class Client
    include HTTParty

    base_uri 'http://collections.walkerart.org/oai'

    attr_accessor :identified
    
    def identifiers
      ['repositoryName', 'baseURL', 'protocolVersion',
       'earliestDatestamp', 'deletedRecord', 'granularity']
    end

    def harvest
    end

    def identify
      @identified || get_identity
    end

    def get_identity
      response =  self.class.get('', :query => {verb: "Identify"})
      extract_identity response.body
    end

    def extract_identity body_xml
      noko = Nokogiri(body_xml)
      hash = {}
      identifiers.collect do |element_name|
        value = noko.css(element_name).children.to_s
        hash[element_name.underscore.to_sym] = value
      end
      hash
    end
  end
end
