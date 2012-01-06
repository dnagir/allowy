module Allowy
  module AccessControl
    extend ActiveSupport::Concern
    included do
      attr_reader :context
    end

    module InstanceMethods
      def initialize(ctx)
        @context = ctx
      end

      def can?(action, *args)
        m = "#{action}?"
        raise UndefinedActionError.new unless self.respond_to? m
        send(m, *args)
      end

      def cannot?(*args)
        not can?(*args)
      end

    end

  end
end
