# frozen_string_literal: true

require './lib/key'

RSpec.describe Enigma do
  it 'exists' do
    key = Key.new('12345')

    expect(key).to be_a Key
  end
end
