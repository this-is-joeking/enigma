# frozen_string_literal: true

require './lib/enigma'
require './lib/key'

message_file = File.open(ARGV[0], 'r')
message = message_file.read
message_file.close
enigma = Enigma.new
date = ARGV[2] || enigma.today
encryption = enigma.encrypt(message, Key.new, date)
ciphertext = File.open(ARGV[1], 'w')
ciphertext.write(encryption[:encryption])
ciphertext.close
puts "Created '#{ARGV[1]}' with the key #{encryption[:key]} and the date #{encryption[:date]}"
