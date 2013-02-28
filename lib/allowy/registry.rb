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
      return unless subject

      # Try subject as decorated object
      clazz = class_for "#{subject.class.source_class.name}Access" if subject.class.respond_to?(:source_class)

      # Try subject as an object
      clazz = class_for "#{subject.class.name}Access" unless clazz

      # Try subject as a class
      clazz = class_for "#{subject.name}Access" if !clazz && subject.is_a?(Class)

      return unless clazz # No luck this time
      # create a new instance or return existing
      @registry[clazz] ||= clazz.new(@context)
    end

    def class_for(name)
      name.safe_constantize
    end

  end
end
