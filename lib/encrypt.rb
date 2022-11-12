# frozen_string_literal: true

require './lib/enigma'

message_file = File.open(ARGV[0], 'r')
message = message_file.read
message_file.close
enigma = Enigma.new
encryption = enigma.encrypt(message)
ciphertext = File.open(ARGV[1], 'w')
ciphertext.write(encryption[:encryption])
ciphertext.close
puts encryption[:key]
