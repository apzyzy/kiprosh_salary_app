class ProcessExcelRow
  attr_reader :month, :year, :row, :pf_rate, :gratuity_rate, :earnings_to_exclude_if_empty

  def initialize(month, year, row, opts)
    @month = month
    @year = year
    @row = row
    @pf_rate = opts[:pf_rate]
    @gratuity_rate = opts[:gratuity_rate]
    @earnings_to_exclude_if_empty = opts[:earnings_to_exclude_if_empty]
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
    row_hash['basic pay'].to_f.round
  end

  def days_paid
    row_hash['days paid']
  end

  def deductions
    except(row_to_a[19..22], ['employees contribution to pf (epf)'])
  end

  def earnings
    except(row_to_a[2..17], ['basic pay'])
  end

  def gratuity
    ((basic_pay.to_f * gratuity_rate) / 100).round
  end

  def net_amount
    (total_earnings - total_deductions).round
  end
  alias_method :calculated_net_amount, :net_amount

  def net_amount_in_excel
    row_hash['net amount'].to_f.round
  end

  def net_amount_mismatch?
    calculated_net_amount != net_amount_in_excel
  end

  def pay_slip_period
    "#{month} #{year}"
  end

  def pf_amount
    ((basic_pay.to_f * pf_rate) / 100).round
  end
  alias_method :calculated_pf_amount, :pf_amount

  def pf_amount_from_excel
    row_hash['employees contribution to pf (epf)'].to_f.round
  end

  def pf_amount_mismatch?
    calculated_pf_amount != pf_amount_from_excel
  end

  def remarks
    row_hash['remarks'].split(";")
  end

  def send_concern_email_to_accounts?
    pf_amount_mismatch? || net_amount_mismatch?
  end

  def total_deductions
    deductions.map { |k,v| v.to_f }.sum + pf_amount
  end

  def total_earnings
    earnings.map { |k,v| v.to_f }.sum + basic_pay
  end

  private

  def except(arr, values)
    return arr unless arr.is_a?(Array)
    arr.reject { |a, b| a.downcase.in?(values) || exclude_if_empty?(a, b) }
  end

  def exclude_if_empty?(a, b)
    a.downcase.in?(earnings_to_exclude_if_empty) && b.zero?
  end

  def row_hash
    @row_hash ||= row.map { |k,v| [k.downcase.squish, v] }.to_h
  end

  def row_to_a
    @row_to_a ||= row.to_a.map { |k,v| [k, v.to_f] }
  end
end
