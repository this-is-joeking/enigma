require './lib/enigma'

RSpec.describe Enigma do
  let(:enigma) { Enigma.new }
  it 'exists' do
    expect(enigma).to be_a Enigma
  end


  describe '#date_format()' do
    it 'gets the shift values from date, optional argument if date specified' do
      date1 = '101122'
      date2 = '221292'
      date3 = 200407
      no_date_given = enigma.date_format

      expect(enigma.date_format(date1)).to eq([8, 8, 8, 4])
      expect(enigma.date_format(date2)).to eq([9, 2, 6, 4])
      expect(enigma.date_format(date3)).to eq([5, 6, 4, 9])
      expect(no_date_given.size).to eq(4)

      no_date_given.each do |element|
        expect(element).to be < 10
      end
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

  describe '#shift_values()' do
    it 'takes key and formatted date and returns shift for keys A..D' do
      key1 = Key.new('73009')
      key2 = Key.new('34129')
      date1 = '101122'
      date2 = '240597'
      no_key_or_date_given = enigma.shift_values

      expect(enigma.shift_values(key1, date1)).to eq([0, 11, 8, 13])
      expect(enigma.shift_values(key2, date2)).to eq([13, 18, 12, 11])
      no_key_or_date_given.each do |shift_value|
        expect(shift_value).to be < 27
      end
    end
  end

  describe '#encrypt' do
    it 'returns hash with encrypted message date and key' do
      encryption1 = enigma.encrypt('joe King', '73009', '101122')
      message = 'longer message for encryption big brain test'
      encryption2 = enigma.encrypt(message)
      encryption3 = enigma.encrypt('HELLO WORLD!', '02715', '040895')

      expect(encryption1[:encryption]).to eq('jzmmktvt')
      expect(encryption1[:key]).to eq('73009')
      expect(encryption1[:date]).to eq('101122')
      expect(encryption2[:encryption].size).to eq(message.size)
      expect(encryption2[:encryption]).not_to eq(message)
      expect(encryption2[:date]).to eq(Time.now.strftime('%d%m%y'))
      expect(encryption2[:key].size).to eq(5)
      expect(encryption3[:encryption]).to eq('keder ohulw!')
    end
  end

  describe '#message_to_alph_index()' do
    it 'sets message to downcase and to array of ordinal values' do
      message1 = 'JoE KIng'
      message2 = 'joe king'

      expect(enigma.message_to_alph_index(message1)).to eq([9, 14, 4, 26, 10, 8, 13, 6])
      expect(enigma.message_to_alph_index(message1)).to eq(enigma.message_to_alph_index(message2))
    end

    it 'skips special characters leaving them as a character' do
      message = 'Hello-world!'

      expect(enigma.message_to_alph_index(message)[5]).to eq('-')
      expect(enigma.message_to_alph_index(message)[11]).to eq('!')
    end
  end

  describe '#alph_index_to_message()' do
    it 'takes ordinals and returns string of characters skipping special chars' do
      indices1 = [9, 14, 4, 26, 10, 8, 13, 6]
      indices2 = [9, 14, 4, 26, 10, 8, 13, 6, '!']

      expect(enigma.alph_index_to_message(indices1)).to eq('joe king')
      expect(enigma.alph_index_to_message(indices2)).to eq('joe king!')
    end
  end
end
