require 'active_support/concern'
require 'allowy/matchers'

module Allowy

  module ControllerAuthorizationMacros
    extend ActiveSupport::Concern

    def allowy
      @controller.current_allowy
    end


    def should_authorize_for(*args)
      allowy.should_receive(:authorize!).with(*args)
    end

    def should_not_authorize_for(*args)
      allowy.should_not_receive(:authorize!).with(*args)
    end

    module ClassMethods
      def ignore_authorization!
        before(:each) do
          registry = double 'Registry'
          registry.stub(:can? => true, :cannot? => false, :authorize! => nil, access_control_for!: registry)
          @controller.stub(:current_allowy).and_return registry
        end
      end
    end
  end

end

RSpec.configure do |config|
  config.include Allowy::ControllerAuthorizationMacros, :type => :controller
end

