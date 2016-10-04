class PaySlip < ApplicationRecord
  belongs_to :admin_user

  attr_accessor :file

  validates :month, uniqueness: { scope: :year }
  validates :month, :year, presence: true
  validate :presence_of_file, on: :create
  validate :excel_file_extension, on: :create

  after_create :process_excel

  private

  def presence_of_file
    unless file.present?
      self.errors[:base] << "Please provide .xlsx or .xls file."
      return false
    end
  end

  def process_excel
    ProcessExcel.new(month, year, file).process
  end

  def excel_file_extension
    return unless file.present?
    extension = File.extname(file.original_filename)
    unless extension.in?(%w(.xlsx .xls))
      self.errors[:base] << "Invalid file extension. Please use .xlsx or .xls file."
    end
  end
end
