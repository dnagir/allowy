module Allowy
  class Registry
    def initialize(ctx)
      @context = ctx
      @registry = {}
    end

    def access_control_for!(subject)
      ac = access_control_for subject
      raise UndefinedAccessControl.new("Please define Access Control class for #{subject.inspect}") unless ac
      ac
    end

    def access_control_for(subject)
      # Try subject as decorated object
      klass = class_for subject.class.source_class.name if subject.class.respond_to?(:source_class)

      # Try subject as an object
      klass = class_for subject.class.name unless klass

      # Try subject as a class
      klass = class_for subject.name if !klass && subject.is_a?(Class)

      return unless klass # No luck this time
      # create a new instance or return existing
      @registry[klass] ||= klass.new(@context)
    end

    def class_for(name)
      (name + access_suffix).safe_constantize
    end

    def self.access_suffix
      "Access"
    end

    def access_suffix
      self.class.access_suffix
    end
  end
end
