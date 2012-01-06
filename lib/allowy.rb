require 'active_support/concern'
require "allowy/version"
require "allowy/access_control"
require "allowy/controller_extensions"

module Allowy
  class UndefinedActionError < StandardError; end
end
