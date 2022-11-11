# frozen_string_literal: true

module Date
  def date_format(date = today)
    squared = date.to_i**2
    squared.digits[0..3].reverse
  end

  def today
    Time.now.strftime('%d%m%y')
  end
end
