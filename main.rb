#!/usr/bin/env ruby
require 'bigdecimal'
require 'date'
require 'io/console'

require_relative "lib/currency"
require_relative "lib/interest"
require_relative "lib/investment"
require_relative 'lib/jct'
require_relative "lib/loan"


MENU_OPTIONS = [
  "Currency - Conversion",
  "Currency - Inflation Adjusted Value",
  "Interest - Simple Interest",
  "Interest - Compound Interest",
  "Interest - Future Value of Annuity",
  "Investment - Return on Investment (ROI)",
  "Investment - Compound Annual Growth Rate (CAGR)",
  "JCT - Amount with Tax",
  "JCT - Yearly Amount with Tax",
  "JCT - Amount Separated by Rate",
  "Loan - Equated Monthly Installment (EMI)",
  "Loan - Total Interest Payable",
  "Exit"
]

def read_key
  c = STDIN.getch
  return :ctrl_c if c == "\u0003"
  return c unless c == "\e"
  STDIN.getch
  case STDIN.getch
  when "A" then :up
  when "B" then :down
  else nil
  end
end

def input_date(prompt, allow_empty: false)
  print prompt
  input = gets.chomp
  return Date.today if allow_empty && input.empty?
  Date.parse(input)
rescue
  puts "Invalid date format. Please enter again (YYYY-MM-DD)"
  retry
end

def input_number(prompt)
  print prompt
  input = gets.chomp
  BigDecimal(input)
rescue
  puts "Invalid number format. Please enter again"
  retry
end

def show_menu(selected_index)
  MENU_OPTIONS.each_with_index do |option, index|
    if index == selected_index
      puts ">#{option}"
    else
      puts " #{option}"
    end
  end
end

begin
  loop do
    selected_index = 0
    show_menu(selected_index)
    loop do
      key = read_key
      case key
      when :up
        selected_index = (selected_index - 1) % MENU_OPTIONS.size
        print "\e[#{MENU_OPTIONS.size}A"
        show_menu(selected_index)
      when :down
        selected_index = (selected_index + 1) % MENU_OPTIONS.size
        print "\e[#{MENU_OPTIONS.size}A"
        show_menu(selected_index)
      when "\r"
        puts "\n------------------"
        case MENU_OPTIONS[selected_index]
		# Currency
		when "Currency - Conversion"
          amount = input_number("Amount: ")
          rate = input_number("Conversion Rate: ")
          puts "Converted Amount: #{Currency.currency_conversion(amount, rate)}"
		  puts ""
        when "Currency - Inflation Adjusted Value"
          amount = input_number("Amount: ")
          rate = input_number("Annual Inflation Rate (0.02 for 2%): ")
          years = input_number("Number of Years: ")
          puts "Inflation Adjusted Value: #{Currency.inflation_adjusted_value(amount, rate, years)}"
		  puts ""
		# Interest
        when "Interest - Simple Interest"
          p = input_number("Principal: ")
          r = input_number("Annual Rate (0.02 for 2%): ")
          t = input_number("Years: ")
          puts "Simple Interest: #{Interest.simple_interest(p,r,t)}"
		  puts ""
        when "Interest - Compound Interest"
          p = input_number("Principal: ")
          r = input_number("Annual Rate (0.02 for 2%): ")
          t = input_number("Years: ")
          n = input_number("Compounding times per year (default 1): ")
          puts "Compound Interest: #{Interest.compound_interest(p,r,t,n)}"
		  puts ""
        when "Interest - Future Value of Annuity"
          payment = input_number("Periodic Payment: ")
          rate = input_number("Annual Rate (0.02 for 2%): ")
          n_periods = input_number("Number of periods: ")
          puts "Future Value of Annuity: #{Interest.future_value_annuity(payment, rate, n_periods)}"
		  puts ""
		# Investment
        when "Investment - Return on Investment (ROI)"
          initial = input_number("Initial Investment: ")
          final = input_number("Final Value: ")
          puts "ROI: #{Investment.roi(final, initial)}"
		  puts ""
        when "Investment - Compound Annual Growth Rate (CAGR)"
          initial = input_number("Initial Investment: ")
          final = input_number("Final Value: ")
          periods = input_number("Number of Years: ")
          puts "CAGR: #{Investment.cagr(final, initial, periods)}"
		  puts ""
		# JCT
        when "JCT Amount with Tax"
          amount = input_number("Enter amount: ")
		  date = input_date("Enter date (YYYY-MM-DD, leave empty for today): ", allow_empty: true)
          result = Jct.amount_with_tax(amount, date: date)
          puts "Amount with Tax: #{result}"
		  puts ""
        when "JCT Yearly Amount with Tax"
          amount = input_number("Enter amount: ")
		  amount = Rational(amount)
          start_on = input_date("Enter start date (YYYY-MM-DD): ", allow_empty: true)
          end_on = input_date("Enter end date (YYYY-MM-DD): ", allow_empty: true)
          result = Jct.yearly_amount_with_tax(amount: amount, start_on: start_on, end_on: end_on)
          puts "Yearly Amount with Tax: #{result}"
		  puts ""
        when "JCT Amount Separated by Rate"
          amount = input_number("Enter amount: ")
          amount = Rational(amount)
		  start_on = input_date("Enter start date (YYYY-MM-DD): ", allow_empty: true)
          end_on = input_date("Enter end date (YYYY-MM-DD): ", allow_empty: true)
          result = Jct.amount_separated_by_rate(amount: amount, start_on: start_on, end_on: end_on)
          puts "Amount Separated by Tax Rate:"
          result.each do |rate, amt|
            puts "  Tax rate #{((rate - 1) * 100).to_i}%: #{amt}"
          end
		  puts ""
		# Loan
        when "Loan - Equated Monthly Installment (EMI)"
          principal = input_number("Loan Principal: ")
          rate = input_number("Annual Rate (0.015 for 1.5%): ")
          years = input_number("Loan Period in Years: ")
          emi = Loan.emi(principal, rate, years)
          puts "EMI: #{emi}"
		  puts ""
        when "Loan - Total Interest Payable"
          principal = input_number("Loan Principal: ")
          rate = input_number("Annual Rate (0.015 for 1.5%): ")
          years = input_number("Loan Period in Years: ")
          emi = Loan.emi(principal, rate, years)
          puts "Total Interest Payable: #{Loan.total_interest(principal, emi, years)}"
		  puts ""
		# Exit
        when "Exit"
          puts "Exited."
          exit
        end
        puts "------------------"
        puts "Press any key to return to the menu.\n"
		puts ""
        STDIN.getch
        puts "------------------"
        break
      when :ctrl_c
        puts "Interrupted."
        exit
      end
    end
  end
rescue Interrupt
  puts "Interrupted."
  exit
end
