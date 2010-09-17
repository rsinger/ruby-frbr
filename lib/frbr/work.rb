module FRBR
  module Work
    include FRBR::Group1 
    include FRBR::Group3
    attr_reader :creators, :subjects, :realizations, :related_works, :valid_relationships
    alias :expressions :realizations

    def add_creator(creator)
      raise ArgumentError, "Creator must be a Group 2 entity" unless creator.is_a?(FRBR::Group2)
      @creators ||= []
      @creators << creator unless @creators.index(creator)
      creator.add_creation(self) unless creator.creator_of?(self)
    end
    
    def remove_creator(creator)
      @creators.delete(creator)
      creator.remove_creation(self) if creator.creator_of?(self)
    end
    
    def has_creator?(agent)
      return true if @creators && @creators.index(agent)
      return false
    end
    
    def add_realization(expression)
      raise ArgumentError, "Only Expressions can be realizations" unless expression.is_a?(FRBR::Expression)
      @realizations ||= []
      @realizations << expression unless @realizations.index(expression)
      expression.is_realization_of(self)
    end
    
    alias_method :add_expression, :add_realization
    
    def remove_realization(expression)
      @realizations.delete(expression) if realizations
      expression.clear_realization_of
    end
    
    alias_method :remove_expression, :remove_realization
    
    def add_subject(subject)
      raise ArgumentError, "Subject must be a Group 3 entity" unless subject.is_a?(FRBR::Group3)
      @subjects ||= []
      @subjects << subject
      subject.add_subject_of(self) unless subject.subject_of.index(self)
    end
    
    def remove_subject(subject)
      @subjects.delete(subject) if @subjects
      subject.remove_subject_of(self) if subject.subject_of.index(self)
    end    
    
    def add_related(work)
      (action, relationship) = this_method.split("_")
      self.add_relationship_to_entity(work, relationship.to_sym, FRBR::Work, true)
    end
    
    def remove_related(work)
      (action, relationship) = this_method.split("_")
      self.remove_relationship_from_entity(work, relationship.to_sym, FRBR::Work, true)
    end
    
    def self.valid_relationships
      {:derivative=>:based_on, :described_in=>:describes, :complemented_by=>:complements, :augmented_by=>:augments, :contains=>:contained_in, :preceded_by=>:succeeded_by, :adaptation_of=>:adaptation, :related=>:related}      
    end    

    private
    def self.included(o)
      FRBR::Group1.check_frbr_validity(o, self.name)
      add_method_aliases      
    end
    def self.extended(o)
      FRBR::Group1.check_frbr_validity(o, self.name)
      add_method_aliases
    end    
    
    def self.add_method_aliases
      self.valid_relationships.to_a.flatten.each do |rel|
        next if rel == :related
        alias_method "add_#{rel}".to_sym, :add_related
        alias_method "remove_#{rel}".to_sym, :remove_related
        alias_method rel, :related
      end
    end
  end
end