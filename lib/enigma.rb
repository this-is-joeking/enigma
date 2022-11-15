# frozen_string_literal: true

require './lib/key'

class Enigma
  def alpha
    ('a'..'z').to_a << ' '
  end

  def date_offset(date)
    squared = date.to_i**2
    squared.digits[0..3].reverse
  end

  def today
    Time.now.strftime('%d%m%y')
  end

  def message_to_alpha_index(message)
    message.downcase.chars.map do |char|
      next char unless alpha.any?(char)

      alpha.find_index(char)
    end
  end

  def alpha_index_to_message(indices)
    indices.map do |index|
      next index unless index.is_a?(Integer)

      alpha[index]
    end.join
  end

  def key_and_date_offsets(key, date)
    combined_offset = []
    key.initial_offset.each_with_index do |element, index|
      combined_offset << element + date_offset(date)[index]
    end
    combined_offset.map { |shift| shift % 27 }
  end

  def shift(message, key, date)
    shift = key_and_date_offsets(key, date)
    encrypted_values = []

    message_to_alpha_index(message).each_with_index do |char, index|
      next encrypted_values << char unless char.is_a?(Integer)

      encrypted_values << (char + shift[index % 4]) % 27
    end
    encrypted_values
  end

  def encrypt(message, key = Key.new, date = today)
    key = Key.new(key) unless key.is_a?(Key)

    encrypted_message = shift(message, key, date)
    { encryption: alpha_index_to_message(encrypted_message),
      key: key.number,
      date: date }
  end

  def unshift(message, key, date)
    shift = key_and_date_offsets(key, date)
    decrypted_values = []

    message_to_alpha_index(message).each_with_index do |char, index|
      next decrypted_values << char unless char.is_a?(Integer)

      decrypted_values << (char - shift[index % 4]) % 27
    end
    decrypted_values
  end

  def decrypt(ciphertext, key, date = today)
    key = Key.new(key)
    decrypted_message = unshift(ciphertext, key, date)
    { decryption: alpha_index_to_message(decrypted_message),
      key: key.number,
      date: date }
  end

  def find_offsets_from_end(ciphertext)
    decrypted_end = message_to_alpha_index(' end')
    encrypted_end = message_to_alpha_index(ciphertext[-4..])
    cracked_shift = []
    encrypted_end.each_with_index do |encrypted_char, index|
      cracked_shift << (encrypted_char - decrypted_end[index]) % 27
    end
    cracked_shift
  end

  def align_offsets(message)
    offsets_from_end = find_offsets_from_end(message)
    offsets_from_end.rotate(4 - message.size % 4)
  end

  def find_key_offsets(offsets, date)
    key_offset = []
    offsets.each_with_index do |offset, index|
      key_offset << (offset - date_offset(date)[index]) % 27
    end
    key_offset
  end

  def find_key(offsets, date)
    key_offset = find_key_offsets(offsets, date)
    ('00000'..'99999').to_a.find do |potential_key|
      key = Key.new(potential_key).initial_offset
      reduced_key = key.map do |offset|
        offset % 27
      end
      reduced_key == key_offset
    end
  end

  def crack(ciphertext, date = today)
    cracked_offsets = align_offsets(ciphertext)
    cracked_key = Key.new(find_key(cracked_offsets, date))
    cracked_message = unshift(ciphertext, cracked_key, date)

    { decryption: alpha_index_to_message(cracked_message),
      date: date,
      key: cracked_key.number }
  end
end
