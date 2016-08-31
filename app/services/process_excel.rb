class ProcessExcel
  attr_accessor :csv_string, :file, :month, :year

  def initialize(month, year, file)
    @file = file
    @month = month
    @year = year
    @csv_string = process_file
  end

  def process
    CSV.parse(csv_string, headers: true).each do |row|
      SendPaySlipJob.perform_later(month, year, row.to_h, global_options)
    end
  end

  private

  def earnings_to_exclude
    exclude = ['basic pay'] # will be added in UI separately
    exclude << 'special allowance' unless Configuration.enabled?('special_allowance')
    exclude << 'telephone reimbusement' unless Configuration.enabled?('telephone_reimbusement')
    exclude
  end

  def global_options
    {
      pf_rate: Configuration.get_value('pf_rate'),
      gratuity_rate: Configuration.get_value('gratuity_rate'),
      excluded_earnings: earnings_to_exclude
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
