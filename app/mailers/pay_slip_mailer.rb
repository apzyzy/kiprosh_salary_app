class PaySlipMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def email_payslip(obj)
    @obj = obj
    # to = obj.associate.email
    name = obj.associate.full_name
    subject = "Salary Slip - #{obj.pay_slip_period}"
    attachments["#{name}.pdf"] = WickedPdf.new.pdf_from_string(
      render_to_string(
        pdf: "#{name}",
        template: 'pay_slip_mailer/pay_slip_template.haml',
        layout: 'mailer.html.erb',
        orientation: 'Landscape',
        locals: { obj: obj }
      )
    )

    mail(
      from:    'accounts@kiprosh.com',
      to:      'varun.lalan@kiprosh.com',
      subject: subject)
  end
end
