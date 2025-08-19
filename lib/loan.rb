require 'bigdecimal'
require 'bigdecimal/util'

module Loan
  def self.emi(principal, annual_rate, years)
    principal = principal.to_d
    monthly_rate = (annual_rate.to_d / 12)
    months = years.to_i * 12
    numerator = principal * monthly_rate * (1 + monthly_rate)**months
    denominator = (1 + monthly_rate)**months - 1
    numerator / denominator
  end

  def self.total_interest(principal, emi, years)
    emi = emi.to_d
    months = years.to_i * 12
    emi * months - principal.to_d
  end
end
