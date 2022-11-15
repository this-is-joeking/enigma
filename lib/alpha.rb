
module Alpha

  def alpha
    ('a'..'z').to_a << ' '
  end

  def message_to_alpha_index(message)
    message.downcase.chars.map do |char|
      next char unless alpha.any?(char)

      alpha.find_index(char)
    end
  end

  def alpha_index_to_message(indices)
    indices.map do |index|
      next index unless index.is_a?(Integer)

      alpha[index]
    end.join
  end

end