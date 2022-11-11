class Enigma

  def key_generator
    key = []
    5.times { key << rand(10) }
    key.join
  end

  def key_format(key)
    key.chars.map { |num| num.to_i }
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
    combined_offset.map { |shift| shift % 27}
  end
end
