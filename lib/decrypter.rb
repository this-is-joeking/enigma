# frozen_string_literal: true

require './lib/key'
require './lib/date'
require './lib/alpha'

class Decrypter
  include Alpha

  attr_reader :message,
              :key,
              :date,
              :ciphertext

  def initialize(ciphertext, key, date)
    @ciphertext = ciphertext
    @key = key
    @date = date
    @message = ''
    decryption
  end

  def key_and_date_offsets(key, date)
    combined_offset = []
    key.initial_offset.each_with_index do |element, index|
      combined_offset << element + date.date_offset[index]
    end
    combined_offset.map { |shift| shift % 27 }
  end

  def unshift
    shift = key_and_date_offsets(@key, @date)
    decrypted_values = []

    message_to_alpha_index(@ciphertext).each_with_index do |char, index|
      next decrypted_values << char unless char.is_a?(Integer)

      decrypted_values << (char - shift[index % 4]) % 27
    end
    decrypted_values
  end

  def decryption
    @message = alpha_index_to_message(unshift)
  end
end
