# frozen_string_literal: true

require './lib/date_mod'

RSpec.describe DateMod do
  let(:test_class) { Class.new { extend DateMod } }
  describe '#date_offset()' do
    it 'gets the shift values from date, optional argument if date specified' do
      date1 = '101122'
      date2 = '221292'
      date3 = 200407
      no_date_given = test_class.date_offset(test_class.today)

      expect(test_class.date_offset(date1)).to eq([8, 8, 8, 4])
      expect(test_class.date_offset(date2)).to eq([9, 2, 6, 4])
      expect(test_class.date_offset(date3)).to eq([5, 6, 4, 9])
      expect(no_date_given.size).to eq(4)

      no_date_given.each do |element|
        expect(element).to be < 10
      end
    end
  end

  describe '#today' do
    it 'turns todays date into string formatted as "DDMMYY"' do
      expect(test_class.today).to be_a String
      expect(test_class.today.size).to eq(6)
      expect(test_class.today[0].to_i).to be <= 3
      expect(test_class.today[2].to_i).to be <= 1
      expect(test_class.today.chars[2..5]).to eq(['1', '1', '2', '2'])
    end
  end
end
