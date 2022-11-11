require './lib/enigma'

RSpec.describe Enigma do
  let(:enigma) { Enigma.new }
  it 'exists' do
    expect(enigma).to be_a Enigma
  end

  describe '#key_generator' do
    it 'generates a random 5 digit number' do
      key = enigma.key_generator

      expect(key.size).to eq(5)
      key.each do |element|
        expect(element).to be_a Integer
        expect(element).to be < (10)
      end
    end
  end

  describe '#key_format()' do
    it 'if key is specified it turns string key to array of integers' do
      key1 = '94724'
      key2 = '01258'

      expect(enigma.key_format(key1)).to eq([9, 4, 7, 2, 4])
      expect(enigma.key_format(key2)).to eq([0, 1, 2, 5, 8])
    end
  end

  describe '#key_to_initial_offset()' do
    it 'turns the 5 random numbers into array of the offsets for ABCD' do
      expect(enigma.key_to_initial_offset([2, 6, 2, 3, 8])).to eq([26, 62, 23, 38])
      expect(enigma.key_to_initial_offset([5, 2, 4, 9, 7])).to eq([52, 24, 49, 97])
    end
  end

  describe '#date_format()' do
    it 'gets the shift values from date, optional argument if date specified' do
      date1 = '101122'
      date2 = '221292'
      date3 = 200407

      expect(enigma.date_format(date1)).to eq([8, 8, 8, 4])
      expect(enigma.date_format(date2)).to eq([9, 2, 6, 4])
      expect(enigma.date_format(date3)).to eq([5, 6, 4, 9])
    end
  end

  describe '#today' do
    it 'turns todays date into string formatted as "DDMMYY"' do
      expect(enigma.today).to be_a String
      expect(enigma.today.size).to eq(6)
      expect(enigma.today[0].to_i).to be <= 3
      expect(enigma.today[2].to_i).to be <= 1
      expect(enigma.today.chars[2..5]).to eq(['1', '1', '2', '2'])
    end
  end
end
