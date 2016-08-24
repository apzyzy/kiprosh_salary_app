# frozen_string_literal: true
class SendPaySlipJob < ApplicationJob
  def perform(month, year, row)
    obj = ProcessExcelRow.new(month, year, row)
    return unless obj.associate

    PaySlipMailer.email_payslip(obj).deliver_now
  end
end
