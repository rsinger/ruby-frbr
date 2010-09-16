module FRBR

  module Group1
    def self.check_frbr_validity(o, mod_name)
      raise TypeError, "Group 1 entities cannot also be Group 2 entities" if o.is_a?(FRBR::Group2)
      entities = [FRBR::Work, FRBR::Expression, FRBR::Manifestation, FRBR::Item, FRBR::Concept, FRBR::Event, FRBR::Object, FRBR::Place]
      entities.delete(Kernel.constant(mod_name))
      entities.each do |e|
        raise TypeError, "#{mod_name} cannot also be a #{e.to_s}" if o.is_a?(e)
      end
    end
  end
  module Group2
    attr_reader :created, :realized, :produced, :owner_of, :related_agents
    
    def add_creation(work)
      raise ArgumentError, "Only Works can be created" unless work.is_a?(FRBR::Work)
      @created ||=[]
      @created << work
      work.add_creator(self) unless work.creators.index(work)
    end
    
    def remove_creation(work)
      @created.delete(work) if @created
    end
    
    def add_realization(expression)    
      raise ArgumentError, "Only Expressions can be realized" unless expression.is_a?(FRBR::Expression)
      @realized ||=[]
      @realized << expression
    end      
    
    def remove_realization(expression)
      @realized.delete(expression) if @realized
    end
    
    def add_production(manifestation)
      raise ArgumentError, "Only Manifestations can be produced" unless manifestation.is_a?(FRBR::Manifestation)
      @produced ||= []
      @produced << manifestation
    end
    
    def remove_production(manifestation)
      @produced.delete(manifestation) if @produced
    end
    
    def add_ownership(item)
      raise ArgumentError, "Only Items can be owned" unless item.is_a?(FRBR::Item)
      @owner_of ||= []
      @owner_of << item
    end
    
    def remove_ownership(item)
      @owner_of.delete(item) if @owner_of
    end
    
    def add_related_agent(agent)
      raise ArgumentError, "Related agents must be Group 2 entities" unless agent.is_a?(FRBR::Group2)
      @related_agents ||=[]
      @related_agents << agent
    end
    
    def remove_related_agent(agent)
      @related_agents.delete(agent) if @related_agents
    end
  end
  module Group3
    attr_reader :subject_of, :related_subjects
    def add_subject_of(work)
      raise ArgumentError, "Group 3 entities can only be subjects of Works" unless work.is_a?(FRBR::Work)
      @subject_of ||= []
      @subject_of << work
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

