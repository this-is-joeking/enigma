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
end
