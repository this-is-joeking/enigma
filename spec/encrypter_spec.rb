# frozen_string_literal: true

require './lib/encrypter'

RSpec.describe Encrypter do
  it 'exists and has readable attributes' do
    encrypter = Encrypter.new('string', Key.new, Date.new)

    expect(encrypter).to be_a Encrypter
    expect(encrypter.message).to eq('string')
    expect(encrypter.date).to be_a Date
    expect(encrypter.key).to be_a Key
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

  describe '#shift()' do
    it 'shifts the values of chars based on shift values' do
      encrypter1 = Encrypter.new('joe King', Key.new('73009'), Date.new('101122'))
      encrypter2 = Encrypter.new('hello world', Key.new('02715'), Date.new('040895'))

      expect(encrypter1.shift).to eq([9, 25, 12, 12, 10, 19, 21, 19])
      expect(encrypter2.shift).to eq([10, 4, 3, 4, 17, 26, 14, 7, 20, 11, 22])
    end
  end

  describe '#encryption' do
    it 'uses shift to turn the array of values into the encrypted message' do
      encrypter1 = Encrypter.new('joe King', Key.new('73009'), Date.new('101122'))
      encrypter2 = Encrypter.new('hello world', Key.new('02715'), Date.new('040895'))

      expect(encrypter1.encryption).to eq('jzmmktvt')
      expect(encrypter2.encryption).to eq('keder ohulw')
    end
  end
end
