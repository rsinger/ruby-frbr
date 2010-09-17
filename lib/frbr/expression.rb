module FRBR
  module Expression
    include FRBR::Group1
    include FRBR::Group3
    attr_reader :realizers, :realization_of, :embodiments
    
    alias :work, :realization_of
    alias :manifestations, :embodiments
    
    def is_realization_of(work)
      raise ArgumentError, "Must be a realization of a work" unless work.is_a?(FRBR::Work)
      @realization_of = work
      work.add_realization(self) unless work.realizations.index(self)
    end
    
    alias_method :is_expression_of, :is_realization_of
    
    def clear_realization_of
      if @realization_of
        w = @realization_of
        @realization_of = nil
        w.remove_realization(self) if w.realizations.index(self)
      end
    end
    
    alias_method :clear_expression_of, :clear_realization_of
    
    def add_realizer(realizer)
      raise ArgumentError, "Realizer must be a Group 2 entity" unless realizer.is_a?(FRBR::Group2)
      @realizers ||= []
      @realizers << realizer unless @realizers.index(realizer)
      realizer.add_realization(self) unless realizer.realizer_of?(self)
    end
    
    def remove_realizer(realizer)
      @realizers.delete(realizer)
      realizer.remove_realization(self) if realizer.realizer_of?(self)
    end    
    
    def has_realizer?(agent)
      return true if @realizers && @realizers.index(agent)
      return false
    end
    
    def add_embodiment(manifestation)
      raise ArgumentError, "Embodiments must be manifestations" unless manifestation.is_a?(FRBR::Manifestation)
      @embodiments ||= []
      @embodiments << manifestation unless @embodiments.index(manifestation)
      manifestation.is_embodiment_of(self)
    end
    
    alias_method :add_manifestation, :add_embodiment
    
    def remove_embodiment(manifestation)
      @embodiments.delete(manifestation) if @embodiments
      manifestation.clear_embodiment_of
    end
    
    alias_method :remove_manifestation, :remove_embodiment
    
    def add_related(expression)
      (action, relationship) = this_method.split("_")
      self.add_relationship_to_entity(expression, relationship.to_sym, FRBR::Expression, true)
    end
    
    def remove_related(expression)
      (action, relationship) = this_method.split("_")
      self.remove_relationship_from_entity(expression, relationship.to_sym, FRBR::Expression, true)
    end
    
    def equivalents
      equivalents = []
      if self.realization_of
        self.realization_of.realizations.each do | expression |
          next if expression == self
          equivalents << expression
        end
      end
      equivalents
    end
        
    def self.valid_relationships
      {:translation=>:translation_of, :revision=>:revision_of, :arrangement=>:arrangement_of, :derivative=>:based_on, :preceded_by=>:succeeded_by, :described_in=>:describes, :augmentation=>:augmentation_of, :contains=>:contained_in, :complemented_by=>:complements, :adaptation=>:adaptation_of, :imitation=>:imitation_of, :related=>:related}      
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
        alias_method "add_#{rel}".to_sym, :add_relationship
        alias_method "remove_#{rel}".to_sym, :remove_relationship
      end
    end   
  end
end