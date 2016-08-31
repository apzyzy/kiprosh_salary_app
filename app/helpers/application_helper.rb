module ApplicationHelper
  def number_to_indian_currency(number)
    return if number.blank?
    "#{INDIAN_CURRENCY_SYMBOL}#{number.to_f.round.to_s.gsub(/(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?/, "\\1,")}"
  end
end

