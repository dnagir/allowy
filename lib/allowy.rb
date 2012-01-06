require 'active_support/concern'
require "allowy/version"
require "allowy/access_control"
require "allowy/registry"
require "allowy/controller_extensions"

module Allowy
  class UndefinedAccessControlError < StandardError; end
  class UndefinedActionError < StandardError; end

  class AccessDenied < StandardError
    attr_reader :action, :subject

    def initialize(message, action, subject)
      @message = message
      @action = action
      @subject = subject
    end
  end
end
