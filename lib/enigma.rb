# frozen_string_literal: true

require './lib/date_mod'
require './lib/key'

class Enigma
  include DateMod

  def alpha
    ('a'..'z').to_a << ' '
  end

  def message_to_alph_index(message)
    message.downcase.chars.map do |char|
      next char unless alpha.any?(char)

      alpha.find_index(char)
    end
  end

  def alph_index_to_message(indices)
    indices.map do |index|
      next index unless index.is_a?(Integer)

      alpha[index]
    end.join
  end

  def shift_values(key, date)
    combined_offset = []
    key.initial_offset.each_with_index do |element, index|
      combined_offset << element + date_offset(date)[index]
    end
    combined_offset.map { |shift| shift % 27 }
  end

  def shift(message, key, date)
    shift = shift_values(key, date)
    encrypted_values = []

    message_to_alph_index(message).each_with_index do |char, index|
      next encrypted_values << char unless char.is_a?(Integer)

      encrypted_values << (char + shift[index % 4]) % 27
    end
    encrypted_values
  end

  def encrypt(message, key = Key.new, date = today)
    key = Key.new(key) unless key.is_a?(Key)
    encrypted_message = shift(message, key, date)
    { encryption: alph_index_to_message(encrypted_message),
      key: key.number,
      date: date }
  end

  def unshift(message, key, date)
    shift = shift_values(key, date)
    decrypted_values = []

    message_to_alph_index(message).each_with_index do |char, index|
      next decrypted_values << char unless char.is_a?(Integer)

      decrypted_values << (char - shift[index % 4]) % 27
    end
    decrypted_values
  end

  def decrypt(ciphertext, key, date = today)
    key = Key.new(key)
    decrypted_message = unshift(ciphertext, key, date)
    { decryption: alph_index_to_message(decrypted_message),
      key: key.number,
      date: date }
  end

  def find_shift(ciphertext)
    decrypted_end = message_to_alph_index(' end')
    encrypted_end = message_to_alph_index(ciphertext[-4..])
    cracked_shift = []
    encrypted_end.each_with_index do |encrypted_char, index|
      cracked_shift << (decrypted_end[index] - encrypted_char) % 27
    end
    cracked_shift
  end

  def align_shift(message, shift)
    shift.rotate(message.size % 4)
  end

  def crack(ciphertext, date = today)
    cracked_shift = find_shift(ciphertext).reverse
    cracked_values = []
    message_to_alph_index(ciphertext.reverse).each_with_index do |char, index|
      next cracked_values << char unless char.is_a?(Integer)

      cracked_values << (char + cracked_shift[index % 4]) % 27
    end
    cracked = alph_index_to_message(cracked_values.reverse)

    { decryption: cracked,
      date: date }
  end
end
