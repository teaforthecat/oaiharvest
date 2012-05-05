require 'nokogiri'
module Oaiharvest
  class Client
    include HTTParty
    include StringSupport

    attr_accessor :identified, :opts, :listed_identifiers


    def initialize opts
      unless self.class.base_uri
        self.class.base_uri( opts.delete(:base_uri){ raise "base_uri required" } )
      end
      opts.delete(:base_uri)
      self.opts = opts
    end

    def harvest
    end

    def list_records opts={}
      @opts.merge!(opts.dup)
      unless @opts.include?(:metadata_prefix)
        raise "metadata_prefix required"
      end
      get_list_records(opts)
    end

    def list_metadata_formats
      get_list_metadata_formats
    end

    def list_identifiers opts={}
      opts = @opts.merge(opts.dup)
      if opts.include?(:set)
        raise "set not allowed in list_identifiers"
      end
      get_list_identifiers
    end

    def list_sets
      get_list_sets
    end

    def identify
      get_identity
    end

    def get_list_records opts
      response = verb("ListRecords", opts)
      warning = response.parsed_response.fetch("OAI_PMH",[])
      if warning.include?('error')
        warning.fetch('error')
      else
        extract_records response.body
      end
    end

    def extract_records body_xml
      noko = Nokogiri(body_xml)
      record = Struct.new(:header,:metadata)
      noko.css('record').collect do |record_element|
        rec = record.new
        rec.header = flat_elements( 'header', record_element )[0]
        rec.metadata = get_metadata( 'metadata', record_element )
        rec
      end
    end

    # we can use 'first' here because only ONE metadata_prefix is ever returned in the body
    def get_metadata element_name, record_element
      metadata = {}
      metadata_element = record_element.css('metadata').children.first
      metadata_element.children.each do |element|
        metadata_element.children.each do |attribute_element|
          if record_element.css('metadata').children.first.name == 'cdwalite'
            key,value = extract_cdwalite_info( attribute_element)
            name = key
            value = value
            if name == 'record'
              next
            end
          else
            name = attribute_element.name
            value = attribute_element.text
          end
          metadata[name] = value
        end
      end
      metadata
    end

    def extract_cdwalite_info attribute_element
      name = attribute_element.name.gsub(/Wrap$/,'')
      value = attribute_element.children.collect(&:text)
      value = value.length == 1 ? value[0] : value
      [name, value]
    end

    def get_list_metadata_formats
      response = verb("ListMetadataFormats")
      extract_formats response.body
    end

    def extract_formats body_xml
      noko = Nokogiri(body_xml)
      flat_elements "metadataFormat", noko
    end
    
    def flat_elements element_name, document
      document.css(element_name).collect do |element|
        head = {}
        element.children.collect do |el| 
          head = head.merge({el.name.underscore => el.text})
        end
        head
      end
    end

    def get_list_identifiers
      response = verb("ListIdentifiers")
      extract_identifiers response.body
    end

    def extract_identifiers body_xml
      noko = Nokogiri(body_xml)
      flat_elements "header", noko
    end

    def get_list_sets
      response = verb("ListSets")
      extract_sets response.body
    end

    def extract_sets body_xml
      noko = Nokogiri(body_xml)
      noko.css('setSpec').children.collect{|el| el.to_s}
    end

    def make_query opts={}
      new_opts = @opts.merge(opts)
      new_opts.each do |k,v|
        new_opts.delete(k)
        new_opts = new_opts.merge({ k.to_s.camelize(false) => v })
      end
      new_opts
    end

    def verb verb, opts={}
      q = make_query(opts).merge({verb: verb})
      self.class.get('', :query => q )
    end

    def get_identity
      response =  verb("Identify")
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

    private

    def identifiers
      ['repositoryName', 'baseURL', 'protocolVersion',
       'earliestDatestamp', 'deletedRecord', 'granularity']
    end

  end
end
