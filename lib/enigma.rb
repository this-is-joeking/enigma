class Enigma

  def key_generator
    key = []
    5.times { key << rand(10) }
    key
  end
end
