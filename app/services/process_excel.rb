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
      SendPaySlipJob.perform_later(month, year, row.to_h)
    end
  end

  private

  def process_file
    obj = Roo::Spreadsheet.open(file)
    truncate(obj.sheet(0).to_csv)
  end

  def truncate(csv_string)
    match = csv_string.match(/\A(.*)"Associate\snumber"/im)
    csv_string.gsub(match[1], '')
  end
end
