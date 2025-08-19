require 'bigdecimal'
require 'bigdecimal/util'

module Currency
  def self.currency_conversion(amount, rate)
    amount.to_d * rate.to_d
  end

  def self.inflation_adjusted_value(amount, inflation_rate, years)
    amount = amount.to_d
    inflation_rate = inflation_rate.to_d
    years = years.to_d
    amount * ((1 + inflation_rate)**years)
  end
end
