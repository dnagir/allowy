require 'pry'
require 'allowy'
require 'allowy/matchers'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.run_all_when_everything_filtered = true
end
