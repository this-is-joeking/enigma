# frozen_string_literal: true

require './lib/cracker'

RSpec.describe Cracker do
  it 'exists and has readable attributes' do
    cracker = Cracker.new('keder ohulwthnw', Date.new)

    expect(cracker).to be_a Cracker
    expect(cracker.ciphertext).to eq('keder ohulwthnw')
    expect(cracker.date).to be_a Date
    expect(cracker.key).to be_a Key
  end

  describe '#find_offsets_from_end' do
    it 'finds how shifted the last 4 characters are in the ciphertext' do
      cracker1 = Cracker.new('Not encrypted message end', Date.new)
      cracker2 = Cracker.new('keder ohulwthnw', Date.new)

      expect(cracker1.find_offsets_from_end).to eq([0, 0, 0, 0])
      expect(cracker2.find_offsets_from_end).to include(3, 0, 19, 20)
    end
  end

  describe '#align_offsets()' do
    it 'aligns the shift so it can start from beginning of message' do
      cracker1 = Cracker.new(' end', Date.new)
      cracker2 = Cracker.new('jzmmktvt!km d', Date.new)
      cracker3 = Cracker.new('keder ohulwthnw', Date.new)

      expect(cracker1.align_offsets).to eq([0, 0, 0, 0])
      expect(cracker2.align_offsets).to eq([0, 11, 8, 13])
      expect(cracker3.align_offsets).to eq([3, 0, 19, 20])
    end
  end

  describe '#find_key_offsets()' do
    it 'returns the shifts created by the key' do
      cracker1 = Cracker.new('jzmmktvt!km d', Date.new('101122'))
      cracker2 = Cracker.new('keder ohulwthnw', Date.new('040895'))

      expect(cracker1.find_key_offsets).to eq([19, 3, 0, 9])
      expect(cracker2.find_key_offsets).to eq([2, 0, 17, 15])
    end
  end

  describe '#find_key()' do
    it 'returns the key' do
      cracker1 = Cracker.new('jzmmktvt!km d', Date.new('101122'))
      cracker2 = Cracker.new('keder ohulwthnw', Date.new('040895'))

      expect(cracker1.find_key).to eq('73009')
      expect(cracker2.find_key).to eq('02715')
    end
  end
end
