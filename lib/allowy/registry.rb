module Allowy
  class Registry
    def initialize(ctx, options={})
      options.assert_valid_keys(:access_suffix)
      @context = ctx
      @registry = {}
      @options = options
    end

    def access_control_for!(subject)
      ac = access_control_for subject
      raise UndefinedAccessControl.new("Please define Access Control class for #{subject.inspect}") unless ac
      ac
    end

    def access_control_for(subject)
      clazz = nil
      # test for overridden source class eg decorated object/class
      if subject.class.respond_to?(:source_class) || subject.respond_to?(:source_class)
        # Try subject as decorated object
        clazz = class_for subject.class.source_class.name if subject.class.respond_to?(:source_class)
        clazz = class_for subject.source_class.name if subject.respond_to?(:source_class)
      else
        # Try subject as an object
        clazz = class_for subject.class.name unless clazz
        # Try subject as a class
        clazz = class_for subject.name if !clazz && subject.is_a?(Class)
      end

      return unless clazz # No luck this time
      # create a new instance or return existing
      @registry[clazz] ||= clazz.new(@context)
    end

    private

    def class_for(name)
      remove_suffix_if_exists = Regexp.new("#{access_suffix}$")
      "#{name.gsub(remove_suffix_if_exists,'')}#{access_suffix}".safe_constantize
    end

    def access_suffix
      @options.fetch(:access_suffix) { 'Access' }
    end

  end
end
