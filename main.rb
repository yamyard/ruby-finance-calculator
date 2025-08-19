#!/usr/bin/env ruby
require 'bigdecimal'
require 'date'
require 'io/console'

require_relative 'lib/jct'

MENU_OPTIONS = [
  "JCT Amount with Tax",
  "JCT Yearly Amount with Tax",
  "JCT Amount Separated by Rate",
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
