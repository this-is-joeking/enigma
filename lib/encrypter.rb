# frozen_string_literal: true

require './lib/key'
require './lib/date'
require './lib/alpha'

class Encrypter
  include Alpha

  attr_reader :message,
              :key,
              :date,
              :ciphertext
  
  def initialize(message, key, date)
    @message = message
    @key = key
    @date = date
    @ciphertext = ''
    encryption
  end

  def key_and_date_offsets
    combined_offset = []
    @key.initial_offset.each_with_index do |element, index|
      combined_offset << element + @date.date_offset[index]
    end
    combined_offset.map { |shift| shift % 27 }
  end

  def shift
    encrypted_values = []
    message_to_alpha_index(message).each_with_index do |char, index|
      next encrypted_values << char unless char.is_a?(Integer)

      encrypted_values << (char + key_and_date_offsets[index % 4]) % 27
    end
    encrypted_values
  end

  def encryption
    @ciphertext = alpha_index_to_message(shift)
  end
end