require './lib/decrypter'

RSpec.describe Decrypter do
  it 'exists and has readable attributes' do
    decrypter = Decrypter.new('string', Key.new, Date.new)

    expect(decrypter).to be_a Decrypter
    expect(decrypter.ciphertext).to eq('string')
    expect(decrypter.date).to be_a Date
    expect(decrypter.key).to be_a Key
  end

  describe '#unshift' do
    it 'unshifts values based of chars based on shift values' do
      expected = Decrypter.new('keder ohulw', Key.new('02715'), Date.new('040895'))
      expect(expected.unshift).to eq([7, 4, 11, 11, 14, 26, 22, 14, 17, 11, 3])
    end
  end
end