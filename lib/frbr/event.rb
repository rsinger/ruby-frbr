module FRBR
  module Event
    include FRBR::Group3 
    def self.included(o)
      FRBR::Group3.check_frbr_validity(o, self.name)  
    end
    def self.extended(o)
      FRBR::Group3.check_frbr_validity(o, self.name)
    end       
  end
end