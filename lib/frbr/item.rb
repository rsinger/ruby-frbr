module FRBR
  module Item
    include FRBR::Group1
    include FRBR::Group3
    attr_reader :exemplar_of, :owners
    alias :manifestation :exemplar_of
    
    def equivalents
      equivalents = []
      if self.exemplar_of
        self.exemplar_of.exemplars.each do | item |
          next if item == self
          equivalents << item
        end
      end
      equivalents
    end  
    
    def is_exemplar_of(manifestation)  
      raise ArgumentError, "Must be the exemplar of a manifestation" unless manifestation.is_a?(FRBR::Manifestation)
      @exemplar_of = manifestation
      manifestation.add_exemplar(self) unless manifestation.exemplars.index(self)
    end
    
    alias_method :is_item_of, :is_exemplar_of
    
    def clear_exemplar_of(manifestation)
      if @exemplar_of
        m = @exemplar_of
        @exemplar_of = nil
        m.remove_exemplars(self) if m.exemplars.index(self)
      end
    end
    
    def has_owner?(agent)      
      return true if @owners && @owners.index(agent)
      return false
    end
    
    alias_method :clear_item_of, :clear_exemplar_of
    
    def add_owner(owner)
      raise ArgumentError, "Owner must be a Group 2 entity" unless owner.is_a?(FRBR::Group2)
      @owners ||= []
      @owners << owner unless @owners.index(owner)
      owner.add_ownership(self) unless owner.owner_of?(self)
    end
    
    def remove_owner(owner)
      @owners.delete(owner)
      owner.remove_owner(self) if owner.owner_of(self)
    end
        
    def add_related(expression)
      (action, relationship) = this_method.split("_")
      self.add_relationship_to_entity(expression, relationship.to_sym, FRBR::Item, true)
    end
    
    def remove_related(expression)
      (action, relationship) = this_method.split("_")
      self.remove_relationship_from_entity(expression, relationship.to_sym, FRBR::Item, true)
    end    

    def self.valid_relationships
      {:reconfiguration=>:reconfiguration_of, :accompanied_by=>:accompanies, :described_in=>:describes, :contains=>:contained_in, :reproduction=>:reproduction_of, :related=>:related}      
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