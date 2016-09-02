class ProcessExcel
  attr_accessor :csv_string, :file, :month, :year

  def initialize(month, year, file)
    @file = file
    @month = month
    @year = year
    @csv_string = process_file
  end

  def process
    opts = global_options

    CSV.parse(csv_string, headers: true).each do |row|
      SendPaySlipJob.perform_later(month, year, row.to_h, opts)
    end
  end

  private

  def earnings_to_exclude_if_empty
    exclude = []
    exclude << Configuration.get_value('special_entries') if Configuration.get("special_entries").present?
    exclude.flatten.reject(&:blank?)
  end

  def global_options
    {
      pf_rate: Configuration.get_value('pf_rate'),
      gratuity_rate: Configuration.get_value('gratuity_rate'),
      earnings_to_exclude_if_empty: earnings_to_exclude_if_empty
    }
  end

  def process_file
    obj = Roo::Spreadsheet.open(file)
    truncate(obj.sheet(0).to_csv)
  end

  def truncate(csv_string)
    match = csv_string.match(/\A(.*)"Associate\snumber"/im)
    csv_string.gsub(match[1], '')
  end
end
