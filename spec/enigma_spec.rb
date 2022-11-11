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

  describe '#key_to_initial_offset()' do
    it 'turns the 5 random numbers into array of the offsets for ABCD' do
      expect(enigma.key_to_initial_offset([2, 6, 2, 3, 8])).to eq([26, 62, 23, 38])
      expect(enigma.ket_to_initial_offset([5, 2, 4, 9, 7])).to eq([52, 24, 49, 97])
    end
  end
end
