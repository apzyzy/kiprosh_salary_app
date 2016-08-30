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
    except(row_to_a[19..22], ['tax deducted at source (tds)'])
  end

  def earnings
    except(row_to_a[2..17], earnings_to_exclude)
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
    rate = Configuration.get_value('pf_rate')
    ((basic_pay.to_i * rate) / 100).floor
  end

  def remarks
    row_hash['remarks'].split(";")
  end

  def tds
    value = row_hash['tax deducted at source (tds)']
    (value == '-' || value.nil?) ? '0' : value
  end

  def total_deductions
    row_to_a[23][1]
  end

  def total_earnings
    row_to_a[18][1]
  end

  private

  def earnings_to_exclude
    exclude = ['basic pay'] # will be added in UI separately
    exclude << 'special allowance' unless Configuration.enabled?('special_allowance')
    exclude << 'telephone reimbusement' unless Configuration.enabled?('telephone_reimbusement')
    exclude
  end

  def except(arr, values)
    return arr unless arr.is_a?(Array)
    arr.reject { |a, b| a.downcase.in? values }
  end

  def row_hash
    @row_hash ||= row.map {|k,v| [k.downcase.squish, v]}.to_h
  end

  def row_to_a
    @row_to_a ||= row.to_a
  end
end
