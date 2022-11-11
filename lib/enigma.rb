# frozen_string_literal: true

class Enigma
  def initialize
    @alphabet = ('a'..'z').to_a << ' '
  end

  def date_format(date = today)
    squared = date.to_i**2
    squared.digits[0..3].reverse
  end

  def today
    Time.now.strftime('%d%m%y')
  end

  def shift_values(key = Key.new, date = today)
    initial_offset = key.formatted_to_initial_offset
    date_offset = date_format(date)
    combined_offset = []
    initial_offset.each_with_index do |element, index|
      combined_offset << element + date_offset[index]
    end
    combined_offset.map { |shift| shift % 27 }
  end

  def encrypt(message, key = Key.new, date = today)
    key = Key.new(key) unless key.is_a?(Key)
    shift = shift_values(key, date)
    encrypted_values = []

    message_to_alph_index(message).each_with_index do |char, index|
      next encrypted_values << char unless char.is_a?(Integer)

      encrypted_values << (char + shift[index % 4]) % 27
    end
    { encryption: alph_index_to_message(encrypted_values),
      key: key.number,
      date: date }
  end

  def message_to_alph_index(message)
    message.downcase.chars.map do |char|
      next char unless @alphabet.any?(char)

      @alphabet.find_index(char)
    end
  end

  def alph_index_to_message(indices)
    indices.map do |index|
      next index unless index.is_a?(Integer)

      @alphabet[index]
    end.join
  end
end
