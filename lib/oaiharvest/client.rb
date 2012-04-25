module Oaiharvest
  class Client
    include HTTParty

    base_uri 'http://collections.walkerart.org/oai'


    def harvest
    end

    def identify
      self.class.get('', :query => {verb: "Identify"})
    end
  end
end
