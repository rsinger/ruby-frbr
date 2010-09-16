module FRBR
  module Manifestation
    include FRBR::Group1
    include FRBR::Group3
    attr_reader :producers, :embodiment_of, :exemplars, :equivalents, :accompanies, :accompanied_by, :describes, :described_in, :contains, :contained_in, :reproductions, :reproduction_of
    
    def self.included(o)
      FRBR::Group1.check_frbr_validity(o, self.name)
    end
    def self.extended(o)
      FRBR::Group1.check_frbr_validity(o, self.name)
    end    
  end
end