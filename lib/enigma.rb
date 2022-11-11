class Enigma

  def key_generator
    key = []
    5.times { key << rand(10) }
    key
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
end
