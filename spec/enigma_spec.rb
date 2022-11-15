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
    end
  end

  describe '#find_offsets_from_end' do
    it 'finds how shifted the last 4 characters are in the ciphertext' do
      expect(enigma.find_offsets_from_end('Not encrypted message end')).to eq([0, 0, 0, 0])
      expect(enigma.find_offsets_from_end('keder ohulwthnw')).to include(3, 0, 19, 20)
      expect(enigma.find_offsets_from_end('keder ohulwthnw')).to eq([20, 3, 0, 19])

      encrypted2 = enigma.encrypt('joe King! end', '73009', '101122')

      expect(enigma.find_offsets_from_end(encrypted2[:encryption])).to include(0, 11, 8, 13)
      expect(enigma.find_offsets_from_end(encrypted2[:encryption])).to eq([11, 8, 13, 0])
    end
  end

  describe '#align_offsets()' do
    it 'aligns the shift so it can start from beginning of message' do
      msg1 = ' end'
      msg2 = 'jzmmktvt!km d'
      msg3 = 'keder ohulwthnw'

      expect(enigma.align_offsets(msg1)).to eq([0, 0, 0, 0])
      expect(enigma.align_offsets(msg2)).to eq([0, 11, 8, 13])
      expect(enigma.align_offsets(msg3)).to eq([3, 0, 19, 20])
    end
  end

  describe '#find_key_offsets()' do
    it 'returns the shifts created by the key' do
      cracked_shift = [0, 11, 8, 13]
      date = Date.new('101122')

      expect(enigma.find_key_offsets(cracked_shift, date)).to eq([19, 3, 0, 9])
    end
  end

  describe '#find_key()' do
    it 'returns the key' do
      shift1 = [0, 11, 8, 13]
      date1 = Date.new('101122')

      expect(enigma.find_key(shift1, date1)).to eq('73009')
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
