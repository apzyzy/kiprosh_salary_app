class PaySlip < ApplicationRecord
  belongs_to :admin_user

  attr_accessor :file

  validates :month, uniqueness: { scope: :year }
  validates :month, :year, presence: true
  validate :xlsx_file_extension, on: :create

  after_create :process_excel

  private

  def xlsx_file_extension
    extension = File.extname(file.original_filename)
    if extension != ".xlsx"
      self.errors[:file] << "Invalid file extension. Please use .xlsx file."
    end
  end

  def process_excel
    ProcessExcel.new(month, year, file).process
  end
end
