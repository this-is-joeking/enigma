# frozen_string_literal: true

class Date
  attr_reader :date

  def initialize(date = today)
    @date = date
  end

  def date_offset
    squared = @date.to_i**2
    squared.digits[0..3].reverse
  end

  def today
    Time.now.strftime('%d%m%y')
  end
end
