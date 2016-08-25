class PaySlip < ApplicationRecord
  belongs_to :admin_user

  attr_accessor :file

  validates :month, uniqueness: { scope: :year }
  validates :month, :year, presence: true
  validate :presence_of_file, on: :create
  validate :xlsx_file_extension, on: :create

  after_create :process_excel

  private

  def presence_of_file
    unless file.present?
      self.errors[:base] << "Please provide xlsx file."
      return false
    end
  end

  def process_excel
    ProcessExcel.new(month, year, file).process
  end

  def xlsx_file_extension
    return unless file.present?
    extension = File.extname(file.original_filename)
    if extension != ".xlsx"
      self.errors[:base] << "Invalid file extension. Please use .xlsx file."
    end
  end
end
