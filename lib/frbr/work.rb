module FRBR
  module Work
    include FRBR::Group1 
    include FRBR::Group3
    attr_reader :creators, :subjects, :realizations, :derivatives, :based_on, :describes, :described_in, :complements, :complemented_by, :augments, :augmented_by, :contains, :contained_in, :preceded_by, :succeeded_by, :adaptations, :adaptation_of, :related_works
    alias :expressions :realizations
    def add_creator(creator)
      raise ArgumentError, "Creator must be a Group 2 entity" unless creator.is_a?(FRBR::Group2)
      @creators ||= []
      @creators << creator unless @creators.index(creator)
      creator.add_creation(self) unless creator.created.index(self)
    end
    
    def remove_creator(creator)
      @creators.delete(creator)
    end
    
    def add_subject(subject)
      raise ArgumentError, "Subject must be a Group 3 entity" unless subject.is_a?(FRBR::Group3)
      @subjects ||= []
      @subjects << subject
    end
    
    def remove_subject(subject)
      @subjects.delete(subject)
    end
    
    def add_realization(expression)
      raise ArgumentError, "Only Expressions can be realizations" unless expression.is_a?(FRBR::Expression)
      @realizations ||= []
      @realizations << expression
    end
    
    def remove_realization(expression)
      @realizations.delete(expression) if realizations
    end
    
    def self.included(o)
      FRBR::Group1.check_frbr_validity(o, self.name)
    end
    def self.extended(o)
      FRBR::Group1.check_frbr_validity(o, self.name)
    end    
  end
end