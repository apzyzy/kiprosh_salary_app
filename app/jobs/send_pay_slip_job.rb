# frozen_string_literal: true
class SendPaySlipJob < ApplicationJob
  def perform(month, year, row, opts)
    obj = ProcessExcelRow.new(month, year, row, opts)
    associate = obj.associate
    return unless associate && associate&.email

    PaySlipMailer.email_payslip(obj).deliver_now

    if obj.send_concern_email_to_accounts?
      AccountsMailer.incorrect_calculation_email(obj).deliver_now
    end
  end
end
