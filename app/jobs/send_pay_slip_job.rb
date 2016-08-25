# frozen_string_literal: true
class SendPaySlipJob < ApplicationJob
  def perform(month, year, row)
    obj = ProcessExcelRow.new(month, year, row)
    associate = obj.associate
    return unless associate && associate&.email

    PaySlipMailer.email_payslip(obj).deliver_now
  end
end
