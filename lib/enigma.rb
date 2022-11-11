class Enigma
  def initialize
    @alphabet = ('a'..'z').to_a << ' '
  end

  def key_generator
    key = []
    5.times { key << rand(10) }
    key.join
  end

  def key_format(key)
    key.chars.map(&:to_i)
  end

  def key_to_initial_offset(key)
    consecutive_key = key.each_cons(2).to_a
    consecutive_key.map { |pair| pair.join.to_i }
  end

  def date_format(date = today)
    squared = date.to_i ** 2
    squared.digits[0..3].reverse
  end

  def today
    Time.now.strftime('%d%m%y')
  end

  def shift_values(key = key_generator, date = today)
    initial_offset = key_to_initial_offset(key_format(key))
    date_offset = date_format(date)
    combined_offset = []
    initial_offset.each_with_index do |element, index|
      combined_offset << element + date_offset[index]
    end
    combined_offset.map { |shift| shift % 27 }
  end

  def encrypt(message, key = key_generator, date = today)
    shift = shift_values(key, date)
    message_values = message_to_ord(message)
    encrypted_values = []

    message_values.each_with_index do |ord_val, index|
      encrypted_values << ord_val + shift[index % 4]
    end
    { encryption: ord_to_message(encrypted_values),
      key: key,
      date: date }
  end

  def message_to_alph_index(message)
    message.downcase.chars.map do |char|
      @alphabet.find_index(char)
    end
  end

  def alph_index_to_message(indices)
    indices.map do |index|
      @alphabet[index]
    end.join
  end
end
