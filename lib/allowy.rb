require 'active_support/concern'
require 'active_support/inflector'

require "allowy/version"
require "allowy/access_control"
require "allowy/registry"
require "allowy/controller_extensions"

module Allowy
  class UndefinedAccessControl < StandardError; end
  class UndefinedAction < StandardError; end

  class AccessDenied < StandardError
    attr_reader :action, :subject

    def initialize(message, action, subject)
      @message = message
      @action = action
      @subject = subject
    end
  end
end
