require "allowy/version"
require 'active_support/concern'

module Allowy
  class UndefinedActionError < StandardError; end

  module AccessControl
    extend ActiveSupport::Concern
    included do
      attr_accessor :context
    end

    module ClassMethods
      def context(*accessors)
        accessors.each do |m|
          attr_accessor m
        end
      end
    end

    module InstanceMethods
      def initialize(context={})
        prepare_context(context)
      end

      def prepare_context(context={})
        @context = context
        context.each_pair do |k,v|
          self.send("#{k}=", v)
        end
        self
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
