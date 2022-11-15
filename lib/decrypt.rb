# frozen_string_literal: true
require './lib/enigma'

encrypted_file = File.open(ARGV[0], 'r')
ciphertext = encrypted_file.read
encrypted_file.close
enigma = Enigma.new

if ARGV[3].nil?
  date = Time.now.strftime('%d%m%y')
else
  date = ARGV[3]
end

decryption = enigma.decrypt(ciphertext, ARGV[2], date)
ciphertext = File.open(ARGV[1], 'w')
ciphertext.write(decryption[:decryption])
ciphertext.close
puts "Created '#{ARGV[1]}' with the key #{decryption[:key]} and the date #{decryption[:date]}"
