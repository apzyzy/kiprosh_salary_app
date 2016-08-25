class ProcessExcelRow
  attr_reader :month, :year, :row

  def initialize(month, year, row)
    @month = month
    @year = year
    @row = row
  end

  def associate
    @associate ||= Associate.where(associate_number: associate_number).first
  end

  def associate_name
    associate&.full_name_with_title
  end

  def associate_designation
    associate&.designation
  end

  def associate_number
    @associate_number ||= row_hash['associate number']
  end

  def associate_pan_number
    associate&.pan_number
  end

  def basic_pay
    row_hash['basic pay']
  end

  def days_paid
    row_hash['days paid']
  end

  def deductions
    reject_empty_values row_to_a[19..22]
  end

  def earnings
    reject_empty_values except_basic_pay(row_to_a[2..17])
  end

  def gratuity
    rate = Configuration.get_value('gratuity_rate')
    ((basic_pay.to_i * rate) / 100).floor
  end

  def net_amount
    row_hash['net amount']
  end

  def pay_slip_period
    "#{month} #{year}"
  end

  def pf_amount
    row_hash['employees contribution to pf']
  end

  def remarks
    row_hash['remarks'].split(";")
  end

  def tds
    value = row_hash['tax deducted at source']
    (value == '-' || value.nil?) ? '0' : value
  end

  def total_deductions
    row_to_a[23][1]
  end

  def total_earnings
    row_to_a[18][1]
  end

  private

  def except_basic_pay(arr)
    return arr unless arr.is_a?(Array)
    arr.reject { |a, b| a.downcase == 'basic pay' }
  end

  def reject_empty_values(arr)
    return arr unless arr.is_a?(Array)
    arr.reject { |a, b| b == '-' || b.blank? || b == "0" }
  end

  def row_hash
    @row_hash ||= row.map {|k,v| [k.downcase.squish, v]}.to_h
  end

  def row_to_a
    @row_to_a ||= row.to_a
  end
end
