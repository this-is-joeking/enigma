require './lib/message'

RSpec.describe Message do
  it 'exists and has an accessible message and alphabet hash' do
    message = Message.new('test')

    expect(message).to be_a Message
    expect(message.input).to eq('test')
  end
end
