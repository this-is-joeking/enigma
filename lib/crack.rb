# frozen_string_literal: true

require './lib/enigma'

encrypted_file = File.open(ARGV[0], 'r')
ciphertext = encrypted_file.read
encrypted_file.close
enigma = Enigma.new
date = ARGV[2] || Time.now.strftime('%d%m%y')
cracked = enigma.crack(ciphertext, date)
cracked_text = File.open(ARGV[1], 'w')
cracked_text.write(cracked[:decryption])
cracked_text.close
puts "Created '#{ARGV[1]}' with the key #{cracked[:key]} and the date #{cracked[:date]}"
