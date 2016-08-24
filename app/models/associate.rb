class Associate < ApplicationRecord
  validates :associate_number, :full_name, :email, presence: true
  validates :title, inclusion: { in: %w(Ms Mr Mrs) }

  def full_name_with_title
    "#{title}. #{full_name}"
  end
end
