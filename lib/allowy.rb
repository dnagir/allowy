require 'active_support/concern'
require "allowy/version"
require "allowy/access_control"
require "allowy/registry"
require "allowy/controller_extensions"

module Allowy
  class UndefinedActionError < StandardError; end
  class UndefinedAccessControlError < StandardError; end
  class UnauthorizedError < StandardError; end
end
