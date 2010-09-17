module FRBR
  module Group1
    attr_reader :relationships
    def self.check_frbr_validity(o, mod_name)
      raise TypeError, "Group 1 entities cannot also be Group 2 entities" if o.is_a?(FRBR::Group2)
      unless mod_name == "FRBR::Group1"
        entities = [FRBR::Work, FRBR::Expression, FRBR::Manifestation, FRBR::Item, FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place]
        entities.delete(Kernel.constant(mod_name))
        entities.each do |e|
          raise TypeError, "#{mod_name} cannot also be a #{e.to_s}" if o.is_a?(e)
        end
      end
      [FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place].each do |subject|
        raise TypeError, "#{subject} cannot be a Group 1 entity" if o.is_a?(subject)
      end
    end
    
    def related
      return @relationships[this_method.to_sym]
    end    
          
    protected
    def add_relationship_to_entity(entity, relationship, entity_type, reify)
      unless entity_type.valid_relationships[relationship] || entity_type.valid_relationships.values.index(relationship)
        raise ArgumentError, "relationship must be one of: #{entity_type.valid_relationships.to_a.flatten.join(", ")}"
      end
      raise ArgumentError, "Relationship must be to another #{entity_type}" unless entity.is_a?(entity_type)
      @relationships ||={}
      @relationships[relationship] ||= []
      @relationships[relationship] << entity unless @relationships[relationship].index(entity)      
      if reify
        if entity_type.valid_relationships[relationship]
          entity.add_relationship_to_entity(self, entity_type.valid_relationships[relationship], entity_type, false)
        else
          entity.add_relationship_to_entity(self, entity_type.valid_relationships.invert[relationship], entity_type, false)
        end
      end
    end      
    
    def remove_relationship_from_entity(entity, relationship, entity_type, reify)
      @relationships[relationship].delete(entity) if @relationships && @relationships[relationship]
      if reify
        if entity_type.valid_relationships[relationship]
          entity.remove_relationship_from_entity(self, entity_type.valid_relationships[relationship], entity_type, false)
        else
          entity.remove_relationship_from_entity(self, entity_type.valid_relationships.invert[relationship], entity_type, false)
        end
      end        
    end
    
    def self.extended(o)
      self.check_frbr_validity(o, self.name)
    end    
    
    def this_method
      caller[0]=~/`(.*?)'/
      $1
    end  
  end
  module Group2
    attr_reader :created, :realized, :produced, :owner_of, :related_agents
    
    def self.check_frbr_validity(o, mod_name)
      raise TypeError, "Group 2 entities cannot also be Group 1 entities" if o.is_a?(FRBR::Group1)
      unless mod_name == "FRBR::Group2"
        entities = [FRBR::Person, FRBR::CorporateBody, FRBR::Family, FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place]
        entities.delete(Kernel.constant(mod_name))
        entities.each do |e|
          raise TypeError, "#{mod_name} cannot also be a #{e.to_s}" if o.is_a?(e)
        end
      end
      [FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place].each do |subject|
        raise TypeError, "#{subject} cannot be a Group 2 entity" if o.is_a?(subject)
      end
    end
    
    def self.extended(o)
      self.check_frbr_validity(o, self.name)
    end    
    
    def creator_of?(thing)
      return true if @created && @created.index(thing)
      return false
    end
    
    def add_creation(work)
      raise ArgumentError, "Only Works can be created" unless work.is_a?(FRBR::Work)
      @created ||=[]
      @created << work unless @created.index(work)
      work.add_creator(self) unless work.has_creator?(work)
    end
    
    def remove_creation(work)
      @created.delete(work) if @created
      work.creators.delete(self) if work.has_creator?(self)
    end
    
    def realizer_of?(thing)
      return true if @realized && @realized.index(thing)
      return false
    end
    
    def add_realization(expression)    
      raise ArgumentError, "Only Expressions can be realized" unless expression.is_a?(FRBR::Expression)
      @realized ||=[]
      @realized << expression unless @realized.index(expression)
      expression.add_realizer(self) unless expression.has_realizer?(self)
    end      
    
    def remove_realization(expression)
      @realized.delete(expression) if @realized
      expression.remove_realizer(self) if expression.has_realizer?(self)
    end
    
    def producer_of?(thing)
      return true if @produced && @produced.index(thing)
      return false
    end
    
    def add_production(manifestation)
      raise ArgumentError, "Only Manifestations can be produced" unless manifestation.is_a?(FRBR::Manifestation)
      @produced ||= []
      @produced << manifestation unless @produced.index(manifestation)
      manifestation.add_producer(self) unless manifestation.has_producer?(self)
    end
    
    def remove_production(manifestation)
      @produced.delete(manifestation) if @produced
      manifestation.remove_producer(self) if manifestation.has_producer?(self)
    end
    
    def owner_of?(thing)
      return true if @owner_of && @owner_of.index(thing)
      return false
    end
    
    def add_ownership(item)
      raise ArgumentError, "Only Items can be owned" unless item.is_a?(FRBR::Item)
      @owner_of ||= []
      @owner_of << item unless @owner_of.index(item)
      item.add_owned_by(self) unless item.has_owner?(self)
    end
    
    def remove_ownership(item)
      @owner_of.delete(item) if @owner_of
      item.remove_owned_by(self) if item.has_owner?(self)
    end
    
    def add_related_agent(agent)
      raise ArgumentError, "Related agents must be Group 2 entities" unless agent.is_a?(FRBR::Group2)
      @related_agents ||=[]
      @related_agents << agent unless @related_agents.index(agent)
      agent.add_related_agent(self) unless agent.related_agents.index(self)
    end
    
    def remove_related_agent(agent)
      @related_agents.delete(agent) if @related_agents
      agent.remove_related_agent(self) if agent.related_agents.index(self)
    end
  end
  module Group3
    attr_reader :subject_of, :related_subjects
    
    def self.check_frbr_validity(o, mod_name)

      unless mod_name == "FRBR::Group3"
        entities = [FRBR::Work, FRBR::Expression, FRBR::Manifestation, FRBR::Item,
          FRBR::Person, FRBR::CorporateBody, FRBR::Family, 
          FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place]
        entities.delete(Kernel.constant(mod_name))
        entities.each do |e|
          raise TypeError, "#{mod_name} cannot also be a #{e.to_s}" if o.is_a?(e)
        end
      end
    end
        
    def add_subject_of(work)
      raise ArgumentError, "Group 3 entities can only be subjects of Works" unless work.is_a?(FRBR::Work)
      @subject_of ||= []
      @subject_of << work unless @subject_of.index(work)
      work.add_subject(self) unless work.subjects.index(self)
    end
    
    def remove_subject_of(work)
      return unless @subject_of
      @subject_of.delete(work)
    end
    
    def add_related_subject(thing)
      raise ArgumentError, "Group 3 entities can only be related to other Group 3 entities" unless thing.is_a?(FRBR::Group3)
      @related_subjects ||= []
      @related_subjects << thing
    end
    
    def remove_related_subject(thing)
      return unless @related_subjects
      @related_subjects.delete(thing)
    end      
  end
end

