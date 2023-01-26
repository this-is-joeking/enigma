# frozen_string_literal: true

require './lib/decrypter'

RSpec.describe Decrypter do
  it 'exists and has readable attributes' do
    decrypter = Decrypter.new('string', Key.new, Date.new)

    expect(decrypter).to be_a Decrypter
    expect(decrypter.ciphertext).to eq('string')
    expect(decrypter.date).to be_a Date
    expect(decrypter.key).to be_a Key
  end

  describe '#key_and_date_offsets()' do
    it 'takes key and formatted date and returns shift for keys A..D' do
      key1 = Key.new('73009')
      key2 = Key.new('34129')
      date1 = Date.new('101122')
      date2 = Date.new('240597')
      encrypter1 = Encrypter.new('string', key1, date1)
      encrypter2 = Encrypter.new('string', key2, date2)

      expect(encrypter1.key_and_date_offsets).to eq([0, 11, 8, 13])
      expect(encrypter2.key_and_date_offsets).to eq([13, 18, 12, 11])
    end
  end

  describe '#unshift' do
    it 'unshifts values based of chars based on shift values' do
      expected1 = Decrypter.new('keder ohulw', Key.new('02715'), Date.new('040895'))
      expected2 = Decrypter.new('jzmmktvt', Key.new('73009'), Date.new('101122'))

      expect(expected1.unshift).to eq([7, 4, 11, 11, 14, 26, 22, 14, 17, 11, 3])
      expect(expected2.unshift).to eq([9, 14, 4, 26, 10, 8, 13, 6])
    end
  end

  describe '#decryption' do
    it 'uses unshift and turns the array of values into decrypted message' do
      expected1 = Decrypter.new('keder ohulw', Key.new('02715'), Date.new('040895'))
      expected2 = Decrypter.new('jzmmktvt', Key.new('73009'), Date.new('101122'))

      expect(expected1.decryption).to eq('hello world')
      expect(expected2.decryption).to eq('joe king')
    end
  end
end
