require 'pry'
require 'allowy'
require 'allowy/matchers'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.run_all_when_everything_filtered = true
end

class SampleAccess
  include Allowy::AccessControl

  def read?(str)
    str == 'allow'
  end

  def early_deny?(str)
    deny! "early terminate: #{str}"
  end

  def context_is_123?(*whatever)
    context === 123
  end
end

class Sample
  attr_accessor :name
end
