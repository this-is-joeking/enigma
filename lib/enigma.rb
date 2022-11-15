# frozen_string_literal: true

require './lib/key'
require './lib/alpha'
require './lib/encrypter'
require './lib/decrypter'

class Enigma
  include Alpha

  def encrypt(message, key = Key.new, date = Date.new)
    key = Key.new(key) unless key.is_a?(Key)

    date = Date.new(date) unless date.is_a?(Date)

    encrypted_message = Encrypter.new(message, key, date)
    { encryption: encrypted_message.ciphertext,
      key: key.number,
      date: date.date }
  end

  def decrypt(ciphertext, key, date = Date.new)
    key = Key.new(key)
    date = Date.new(date) unless date.is_a?(Date)

    decrypted_message = Decrypter.new(ciphertext, key, date)
    { decryption: decrypted_message.message,
      key: key.number,
      date: date.date }
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
      key_offset << (offset - date.date_offset[index]) % 27
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

  def crack(ciphertext, date = Date.new)
    date = Date.new(date) unless date.is_a?(Date)

    cracked_offsets = align_offsets(ciphertext)
    cracked_key = Key.new(find_key(cracked_offsets, date))
    cracked_message = Decrypter.new(ciphertext, cracked_key, date)

    { decryption: cracked_message.message,
      date: date.date,
      key: cracked_key.number }
  end
end
