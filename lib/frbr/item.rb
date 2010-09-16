module FRBR
  module Item
    include FRBR::Group1
    include FRBR::Group3
    attr_reader :exemplar_of, :owners, :reconfigurations, :reconfiguration_of, :accompanied_by, :describes, :described_in, :contains, :contained_in, :reproductions, :reproduction_of, :equivalents
    def self.included(o)
      FRBR::Group1.check_frbr_validity(o, self.name)
    end
    def self.extended(o)
      FRBR::Group1.check_frbr_validity(o, self.name)
    end    
  end
end