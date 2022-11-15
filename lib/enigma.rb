# frozen_string_literal: true

require './lib/key'
require './lib/alpha'
require './lib/encrypter'
require './lib/decrypter'
require './lib/cracker'

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

  def crack(ciphertext, date = Date.new)
    date = Date.new(date) unless date.is_a?(Date)
    cracker = Cracker.new(ciphertext, date)
  
    cracked_message = Decrypter.new(ciphertext, cracker.key, date)

    { decryption: cracked_message.message,
      date: date.date,
      key: cracker.key.number }
  end
end
