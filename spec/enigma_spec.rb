# frozen_string_literal: true

require './lib/enigma'

RSpec.describe Enigma do
  let(:enigma) { Enigma.new }
  it 'exists' do
    expect(enigma).to be_a Enigma
  end

  describe '#alpha' do
    it 'makes an array of downcase alphabet and space' do
      expect(enigma.alpha).to eq(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
                                  'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
                                  's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ' '])
    end
  end

  describe '#message_to_alpha_index()' do
    it 'sets message to downcase and to array of values aligned with #alpha' do
      message1 = 'JoE KIng'
      message2 = 'joe king'
      message3 = 'Hello world'
      expected1 = enigma.message_to_alpha_index(message1)
      expected2 = enigma.message_to_alpha_index(message2)
      expected3 = enigma.message_to_alpha_index(message3)

      expect(expected1).to eq([9, 14, 4, 26, 10, 8, 13, 6])
      expect(expected1).to eq(expected2)
      expect(expected3).to eq([7, 4, 11, 11, 14, 26, 22, 14, 17, 11, 3])
    end

    it 'skips special characters leaving them as a character' do
      message = 'Hello-world!'

      expect(enigma.message_to_alpha_index(message)[5]).to eq('-')
      expect(enigma.message_to_alpha_index(message)[11]).to eq('!')
    end
  end

  describe '#alpha_index_to_message()' do
    it 'takes ordinals and returns string of characters skipping special chars' do
      indices1 = [9, 14, 4, 26, 10, 8, 13, 6]
      indices2 = [9, 14, 4, 26, 10, 8, 13, 6, '!']

      expect(enigma.alpha_index_to_message(indices1)).to eq('joe king')
      expect(enigma.alpha_index_to_message(indices2)).to eq('joe king!')
    end
  end

  describe '#offset_values()' do
    it 'takes key and formatted date and returns shift for keys A..D' do
      key1 = Key.new('73009')
      key2 = Key.new('34129')
      date1 = '101122'
      date2 = '240597'

      expect(enigma.offset_values(key1, date1)).to eq([0, 11, 8, 13])
      expect(enigma.offset_values(key2, date2)).to eq([13, 18, 12, 11])
    end
  end

  describe '#shift()' do
    it 'shifts the values of chars based on shift values' do
      expected1 = enigma.shift('joe King', Key.new('73009'), '101122')
      expected2 = enigma.shift('hello world', Key.new('02715'), '040895')

      expect(expected1).to eq([9, 25, 12, 12, 10, 19, 21, 19])
      expect(expected2).to eq([10, 4, 3, 4, 17, 26, 14, 7, 20, 11, 22])
    end
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

  describe '#unshift' do
    it 'unshifts values based of chars based on shift values' do
      expected = enigma.unshift('keder ohulw', Key.new('02715'), '040895')
      expect(expected).to eq([7, 4, 11, 11, 14, 26, 22, 14, 17, 11, 3])
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

  describe '#find_shift' do
    it 'finds how shifted the last 4 characters are in the ciphertext' do
      expect(enigma.find_shift('Not encrypted message end')).to eq([0, 0, 0, 0])
      expect(enigma.find_shift('keder ohulwthnw')).to include(3, 0, 19, 20)
      expect(enigma.find_shift('keder ohulwthnw')).to eq([20, 3, 0, 19])

      encrypted2 = enigma.encrypt('joe King! end', '73009', '101122')

      expect(enigma.find_shift(encrypted2[:encryption])).to include(0, 11, 8, 13)
      expect(enigma.find_shift(encrypted2[:encryption])).to eq([11, 8, 13, 0])
    end
  end

  describe '#align_offsets()' do
    it 'aligns the shift so it can start from beginning of message' do
      shift1 = [1, 2, 3, 4]
      shift2 = [11, 8, 13, 0]
      shift3 = [20, 3, 0, 19]
      msg1 = ' end'
      msg2 = 'jzmmktvt!km d'
      msg3 = 'keder ohulwthnw'

      expect(enigma.align_offsets(msg1, shift1)).to eq([1, 2, 3, 4])
      expect(enigma.align_offsets(msg2, shift2)).to eq([0, 11, 8, 13])
      expect(enigma.align_offsets(msg3, shift3)).to eq([3, 0, 19, 20])
    end
  end

  describe '#find_key_offset()' do
    it 'returns the shifts created by the key' do
      cracked_shift = [0, 11, 8, 13]
      date = '101122'

      expect(enigma.find_key_offset(cracked_shift, date)).to eq([19, 3, 0, 9])
    end
  end

  describe '#find_key()' do
    it 'returns the key' do
      shift1 = [0, 11, 8, 13]
      date1 = '101122'

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
