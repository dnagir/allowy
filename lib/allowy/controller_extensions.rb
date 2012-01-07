module Allowy

  module ControllerExtensions
    extend ActiveSupport::Concern
    included do
      helper_method :can?, :cannot?
    end

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

if defined? ActionController
  ActionController::Base.send(:include, Allowy::ControllerExtensions)
end
