# frozen_string_literal: true

require './lib/enigma'

RSpec.describe Enigma do
  let(:enigma) { Enigma.new }
  it 'exists' do
    expect(enigma).to be_a Enigma
  end

  describe '#encrypt' do
    it 'returns hash with encrypted message date and key' do
      encryption1 = enigma.encrypt('joe King', '73009', '101122')
      message = 'longer message for encryption big brain test'
      encryption2 = enigma.encrypt(message)
      encryption3 = enigma.encrypt('HELLO WORLD!', '02715', '040895')

      expect(encryption1[:encryption]).to eq('jzmmktvt')
      expect(encryption1[:key]).to eq('73009')
      expect(encryption1[:date]).to eq('101122')
      expect(encryption2[:encryption].size).to eq(message.size)
      expect(encryption2[:encryption]).not_to eq(message)
      expect(encryption2[:date]).to eq(Time.now.strftime('%d%m%y'))
      expect(encryption2[:key].size).to eq(5)
      expect(encryption3[:encryption]).to eq('keder ohulw!')
    end
  end

  describe '#decrypt' do
    it 'returns hash with decrypted message, key, and date' do
      expect(enigma.decrypt('keder ohulw', '02715', '040895')).to eq(
        {
          decryption: 'hello world',
          key: '02715',
          date: '040895'
        }
      )
      expect(enigma.decrypt('jzmmktvt', '73009', '101122')).to eq(
        {
          decryption: 'joe king',
          key: '73009',
          date: '101122'
        }
      )
    end
  end

  describe '#crack()' do
    it 'cracks an encrypted message and date' do
      cracked1 = enigma.crack('vjqtbeaweqihssi', '291018')
      cracked2 = enigma.crack('svhrzwrzsvdzdac', '131122')
      encrypted = enigma.encrypt('and they lived happily ever after, the end')
      cracked3 = enigma.crack(encrypted[:encryption])

      expect(cracked1[:decryption]).to eq('hello world end')
      expect(cracked1[:date]).to eq('291018')
      expect(cracked1[:key]).to eq('08304')
      expect(cracked2[:decryption]).to eq('this is the end')
      expect(cracked2[:date]).to eq('131122')
      expect(cracked2[:key]).to eq('18722')
      expect(cracked3[:decryption]).to eq('and they lived happily ever after, the end')
      expect(cracked3[:date]).to eq(Time.now.strftime('%d%m%y'))
    end
  end
end
