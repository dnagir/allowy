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

      def can?(action, subject)
        raise UndefinedActionError.new unless self.respond_to? action
        send(action, subject)
      end

      def cannot?(action, subject)
        !can?(action, subject)
      end

    end

  end

end
