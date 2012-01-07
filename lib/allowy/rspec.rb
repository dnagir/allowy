require 'allowy/matchers'

module Allowy

  module ControllerAuthorizationMacros
    def ignore_authorization!
      before(:each) do
        registry = double 'Registry'
        registry.stub(:can? => true, :cannot? => false, :authorize! => nil, access_control_for!: registry)
        @controller.stub(:current_allowy).and_return registry
      end
    end
  end

end

RSpec.configure do |config|
  config.extend Allowy::ControllerAuthorizationMacros, :type => :controller
end

