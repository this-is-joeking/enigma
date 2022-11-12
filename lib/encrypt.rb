require './lib/enigma'

plain_text = ARGV[0].prepend('./lib/')
encrypted_text = ARGV[1].prepend('./lib/')
enigma = Enigma.new
ciphertext = enigma.encrypt(File.read(plain_text))
File.write(encrypted_text, ciphertext[:encryption])
