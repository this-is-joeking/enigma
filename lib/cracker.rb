# frozen_string_literal: true

require './lib/key'
require './lib/date'
require './lib/alpha'

class Cracker
  include Alpha

  attr_reader :ciphertext,
              :date,
              :key

  def initialize(ciphertext, date)
    @ciphertext = ciphertext
    @date = date
    @key = Key.new(find_key)
  end

  def find_offsets_from_end
    decrypted_end = message_to_alpha_index(' end')
    encrypted_end = message_to_alpha_index(@ciphertext[-4..])
    cracked_shift = []
    encrypted_end.each_with_index do |encrypted_char, index|
      cracked_shift << (encrypted_char - decrypted_end[index]) % 27
    end
    cracked_shift
  end

  def align_offsets
    offsets_from_end = find_offsets_from_end
    offsets_from_end.rotate(4 - @ciphertext.size % 4)
  end

  def find_key_offsets
    key_offset = []
    align_offsets.each_with_index do |offset, index|
      key_offset << (offset - @date.date_offset[index]) % 27
    end
    key_offset
  end

  def find_key
    key_offset = find_key_offsets
    ('00000'..'99999').to_a.find do |potential_key|
      key = Key.new(potential_key).initial_offset
      reduced_key = key.map do |offset|
        offset % 27
      end
      reduced_key == key_offset
    end
  end
end