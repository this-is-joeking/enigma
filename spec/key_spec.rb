# frozen_string_literal: true

require './lib/key'

RSpec.describe Key do
  it 'exists and can return the key' do
    key = Key.new('12345')

    expect(key).to be_a Key
    expect(key.number).to eq('12345')
  end

  describe '#key_generator' do
    it 'generates a random 5 digit number if no key is given' do
      key = Key.new
      random_key = key.number

      expect(random_key.size).to eq(5)
      random_key.to_i.digits.each do |element|
        expect(element).to be_a Integer
        expect(element).to be < (10)
      end
    end
  end

  describe '#format_to_array()' do
    it 'if key is specified it turns string key to array of integers' do
      key1 = Key.new('94724')
      key2 = Key.new('01258')

      expect(key1.format_to_array).to eq([9, 4, 7, 2, 4])
      expect(key2.format_to_array).to eq([0, 1, 2, 5, 8])
    end
  end

  describe '#initial_offset()' do
    it 'turns the 5 random numbers into array of the offsets for ABCD' do
      key1 = Key.new('26238')
      key2 = Key.new('52497')

      expect(key1.initial_offset).to eq([26, 62, 23, 38])
      expect(key2.initial_offset).to eq([52, 24, 49, 97])
    end
  end
end
