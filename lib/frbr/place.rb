module FRBR
  module Place
    include FRBR::Group3    
    attr_reader :location_of
    def self.included(o)
      FRBR::Group3.check_frbr_validity(o, self.name)  
    end
    def self.extended(o)
      FRBR::Group3.check_frbr_validity(o, self.name)
    end    
  end
end