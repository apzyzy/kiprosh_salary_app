class AccountsMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: 'do-not-reply@kiprosh.com'
  default to: Settings.mailer.test_accounts_email #|| 'accounts@kiprosh.com'

  def incorrect_calculation_email(obj)
    @obj = obj
    name = obj.associate.full_name
    subject = "CONCERN - Calculation issues while processing pay slip for #{name}"

    attachments["#{name}.pdf"] = attach_pay_slip(obj)
    mail(subject: subject)
  end
end
