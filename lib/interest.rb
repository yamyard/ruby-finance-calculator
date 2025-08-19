require 'bigdecimal'
require 'bigdecimal/util'

module Interest
  def self.simple_interest(principal, rate, time)
    principal = principal.to_d
    rate = rate.to_d
    time = time.to_d
    principal * rate * time
  end

  def self.compound_interest(principal, rate, time, n=1)
    principal = principal.to_d
    rate = rate.to_d
    time = time.to_d
    n = n.to_d
    principal * ((1 + rate/n)**(n*time) - 1)
  end

  def self.future_value_annuity(payment, rate, n_periods)
    payment = payment.to_d
    rate = rate.to_d
    n_periods = n_periods.to_d
    payment * (((1 + rate)**n_periods - 1) / rate)
  end
end
