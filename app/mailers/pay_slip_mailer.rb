class PaySlipMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: 'accounts@kiprosh.com'

  def email_payslip(obj)
    to = obj.associate.email
    name = obj.associate.full_name
    subject = "Salary Slip - #{obj.pay_slip_period}"

    attachments["#{name}.pdf"] = WickedPdf.new.pdf_from_string(
      render_to_string(
        pdf: "#{name}",
        template: 'pay_slip_mailer/pay_slip_template.haml',
        layout: 'mailer.html.erb',
        locals: { obj: obj }
      )
    )

    mail(to: test_recipient || to, subject: subject)
  end

  private

  def test_recipient
    Settings.mailer.test_recipient
  end
end
