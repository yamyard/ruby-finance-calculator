require 'bigdecimal'
require 'bigdecimal/util'

module Investment
  def self.roi(final_value, initial_value)
    final_value = final_value.to_d
    initial_value = initial_value.to_d
    (final_value - initial_value) / initial_value
  end

  def self.cagr(final_value, initial_value, periods)
    final_value = final_value.to_d
    initial_value = initial_value.to_d
    periods = periods.to_d
    (final_value / initial_value)**(1/periods) - 1
  end
end
