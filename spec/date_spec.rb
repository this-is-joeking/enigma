# frozen_string_literal: true

require './lib/date'

RSpec.describe Date do
  it 'exists and if no argument given defaults to todays date' do
    date = Date.new

    expect(date).to be_a Date
    expect(date.date).to eq(Time.now.strftime('%d%m%y'))
  end

  describe '#date_offset()' do
    it 'gets the shift values from date, optional argument if date specified' do
      date1 = Date.new('101122')
      date2 = Date.new('221292')
      date3 = Date.new(200407)
      no_date_given = Date.new.date_offset

      expect(date1.date_offset).to eq([8, 8, 8, 4])
      expect(date2.date_offset).to eq([9, 2, 6, 4])
      expect(date3.date_offset).to eq([5, 6, 4, 9])
      expect(no_date_given.size).to eq(4)

      no_date_given.each do |element|
        expect(element).to be < 10
      end
    end
  end

  describe '#today' do
    it 'turns todays date into string formatted as "DDMMYY"' do
      date = Date.new
      
      expect(date.today).to be_a String
      expect(date.today.size).to eq(6)
      expect(date.today[0].to_i).to be <= 3
      expect(date.today[2].to_i).to be <= 1
      expect(date.today.chars[2..5]).to eq(['1', '1', '2', '2'])
    end
  end
end
