# frozen_string_literal: true

class Key
  attr_reader :number

  def initialize(number = key_generator)
    @number = number
  end

  def key_generator
    key = []
    5.times { key << rand(10) }
    key.join
  end

  def format_to_array
    @number.chars.map(&:to_i)
  end

  def formatted_to_initial_offset
    consecutive_key = format_to_array.each_cons(2).to_a
    consecutive_key.map { |pair| pair.join.to_i }
  end

end
