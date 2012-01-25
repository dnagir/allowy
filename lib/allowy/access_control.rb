module Allowy
  module AccessControl
    extend ActiveSupport::Concern
    included do
      attr_reader :context
    end

    def initialize(ctx)
      @context = ctx
    end

    def can?(action, *args)
      m = "#{action}?"
      raise UndefinedAction.new("The #{self.class.name} needs to have #{m} method. Please define it.") unless self.respond_to? m
      send(m, *args)
    end

    def cannot?(*args)
      not can?(*args)
    end

    def authorize!(*args)
      raise AccessDenied.new("Not authorized", args.first, args[1]) unless can?(*args)
    end
  end

end
