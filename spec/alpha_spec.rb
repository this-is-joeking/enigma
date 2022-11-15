# frozen_string_literal: true

require './lib/alpha'

RSpec.describe Alpha do
  let(:test_class) { Class.new { extend Alpha } }

  describe '#alpha' do
    it 'makes an array of downcase alphabet and space' do
      expect(test_class.alpha).to eq(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
                                      'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
                                      's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ' '])
    end
  end

  describe '#message_to_alpha_index()' do
    it 'sets message to downcase and to array of values aligned with #alpha' do
      message1 = 'JoE KIng'
      message2 = 'joe king'
      message3 = 'Hello world'
      expected1 = test_class.message_to_alpha_index(message1)
      expected2 = test_class.message_to_alpha_index(message2)
      expected3 = test_class.message_to_alpha_index(message3)

      expect(expected1).to eq([9, 14, 4, 26, 10, 8, 13, 6])
      expect(expected1).to eq(expected2)
      expect(expected3).to eq([7, 4, 11, 11, 14, 26, 22, 14, 17, 11, 3])
    end

    it 'skips special characters leaving them as a character' do
      message = 'Hello-world!'

      expect(test_class.message_to_alpha_index(message)[5]).to eq('-')
      expect(test_class.message_to_alpha_index(message)[11]).to eq('!')
    end
  end

  describe '#alpha_index_to_message()' do
    it 'takes ordinals and returns string of characters skipping special chars' do
      indices1 = [9, 14, 4, 26, 10, 8, 13, 6]
      indices2 = [9, 14, 4, 26, 10, 8, 13, 6, '!']

      expect(test_class.alpha_index_to_message(indices1)).to eq('joe king')
      expect(test_class.alpha_index_to_message(indices2)).to eq('joe king!')
    end
  end
end
