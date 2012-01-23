module Allowy

  # This module provides the default and common context to for checking the permissions.
  # It is mixed into the Controller in Rails by default and provides an wasy way to reuse it
  # in other parts of the application (in RSpec or Cucumber) without needint a controller.
  # For example, you can use this code in your Cucumber features:
  #
  #   @example
  #   class CustomContext
  #     include Allowy::Context
  #     attr_accessor :current_user
  #
  #     def initialize(user)
  #       @current_user = user
  #     end
  #
  # And the you can easily check the permissions simply using something like:
  #
  #   @example
  #   CustomContext.new(that_user).should be_able_to :create, Blog
  module Context
    extend ActiveSupport::Concern

    module InstanceMethods

      def allowy_context
        self
      end

      def current_allowy
        @current_allowy ||= ::Allowy::Registry.new(allowy_context)
      end

      def can?(action, subject, *args)
        current_allowy.access_control_for!(subject).can?(action, subject, *args)
      end

      def cannot?(*args)
        current_allowy.access_control_for!(subject).cannot?(action, subject, *args)
      end

      def authorize!(action, subject, *args)
        current_allowy.access_control_for!(subject).authorize!(action, subject, *args)
      end
    end
  end

end
