module FRBR
  module Family
    include FRBR::Group2
    include FRBR::Group3
    def self.included(o)
      FRBR::Group2.check_frbr_validity(o, self.name)  
    end
    def self.extended(o)
      FRBR::Group2.check_frbr_validity(o, self.name)
    end    
  end
end