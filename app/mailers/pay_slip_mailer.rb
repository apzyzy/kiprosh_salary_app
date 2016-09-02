class PaySlipMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: 'accounts@kiprosh.com'

  def email_payslip(obj)
    to = obj.associate.email
    name = obj.associate.full_name
    subject = "Salary Slip - #{obj.pay_slip_period}"

    attachments["#{name}.pdf"] = attach_pay_slip(obj)
    mail(to: test_recipient || to, subject: subject)
  end

  private

  def test_recipient
    Settings.mailer.test_recipient
  end
end
