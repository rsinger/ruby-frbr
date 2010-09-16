module FRBR
  module Expression
    include FRBR::Group1
    include FRBR::Group3
    attr_reader :realizers, :realization_of, :translations, :translation_of, :revisions, :revision_of, :embodiments, :arrangements, :arrangement_of, :derivatives, :based_on, :preceded_by, :succeeded_by, :described_in, :describes, :augmentations, :augmentation_of, :contained_in, :contains, :complements, :complemented_by, :adaptations, :adaptation_of, :imitations, :imitation_of
    
    def self.included(o)
      FRBR::Group1.check_frbr_validity(o, self.name)
    end
    def self.extended(o)
      FRBR::Group1.check_frbr_validity(o, self.name)
    end    
  end
end