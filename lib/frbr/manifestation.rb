module FRBR
  module Manifestation
    include FRBR::Group1
    include FRBR::Group3
    attr_reader :producers, :embodiment_of, :exemplars
    
    alias :expression :embodiment_of
    alias :items :exemplars
    
    def equivalents
      equivalents = []
      if self.embodiment_of
        self.embodiment_of.embodiments.each do | manifestation |
          next if manifestation == self
          equivalents << manifestation
        end
      end
      equivalents
    end  
    
    def is_embodiment_of(expression)      
      raise ArgumentError, "Must be the embodiment of an expression" unless expression.is_a?(FRBR::Expression)
      @embodiment_of = expression
      expression.add_embodiment(self) unless expression.embodiments.index(self)
    end
    
    alias_method :is_manifestation_of, :is_embodiment_of
    
    def clear_embodiment_of
      if @embodiment_of && !@embodiment_of.nil?
        if @embodiment_of.embodiments && @embodiment_of.embodiments.index(self)
          @embodiment_of.remove_embodiment(self)
        end
        @embodiment_of = nil
      end
    end
    
    alias_method :clear_manifestation_of, :clear_embodiment_of
    
    def add_exemplar(item)
      raise ArgumentError "Exemplar must an item" unless item.is_a?(FRBR::Item)
      @exemplars ||= []
      @exemplars << item unless @exemplars.index(item)
      item.is_exemplar_of(self)
    end
    
    alias_method :add_item, :add_exemplar
    
    def remove_exemplar(item)
      @exemplars.delete(item) if @exemplars
      item.clear_exemplar_of
    end
    
    alias_method :remove_item, :remove_exemplar
    
    def add_producer(producer)
      raise ArgumentError, "Producer must be a Group 2 entity" unless producer.is_a?(FRBR::Group2)
      @producers ||= []
      @producers << producer unless @producers.index(producer)
      producer.add_production(self) unless producer.producer_of?(self)
    end
    
    def remove_producer(producer)
      @producers.delete(producer)
      producer.remove_production(self) if producer.producer_of?(self)
    end 
    
    def has_producer?(agent)  
      return true if @producers && @producers.index(agent)
      return false
    end
    
    def add_related(expression)
      (action, relationship) = this_method.split("_")
      self.add_relationship_to_entity(expression, relationship.to_sym, FRBR::Manifestation, true)
    end
    
    def remove_related(expression)
      (action, relationship) = this_method.split("_")
      self.remove_relationship_from_entity(expression, relationship.to_sym, FRBR::Manifestation, true)
    end     
    
    def self.valid_relationships
      {:accompanied_by=>:accompanies, :described_in=>:describes, :contains=>:contained_in, :reproduction=>:reproduction_of, :related=>:related}      
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