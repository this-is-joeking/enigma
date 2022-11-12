# frozen_string_literal: true

module DateMod
  def date_offset(date)
    squared = date.to_i**2
    squared.digits[0..3].reverse
  end

  def today
    Time.now.strftime('%d%m%y')
  end
end
