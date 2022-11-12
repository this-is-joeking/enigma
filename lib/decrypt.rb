# frozen_string_literal: true

require './lib/enigma'

encrypted_file = File.open(ARGV[0], 'r')
ciphertext = encrypted_file.read
encrypted_file.close
enigma = Enigma.new
decryption = enigma.decrypt(ciphertext, ARGV[2], ARGV[3])
ciphertext = File.open(ARGV[1], 'w')
ciphertext.write(decryption[:decryption])
ciphertext.close
