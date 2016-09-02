class AccountsMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  default from: 'do-not-reply@kiprosh.com'

  def incorrect_calculation_email(obj)
    @obj = obj
    name = obj.associate.full_name
    subject = "CONCERN - Calculation issues while processing pay slip for #{name}"

    attachments["#{name}.pdf"] = attach_pay_slip(obj)
    mail(
      to: accounts_email,
      cc: Settings.mailer.cc_accounts_email,
      subject: subject)
  end

  private

  def accounts_email
    Settings.mailer.test_accounts_email || 'accounts@kiprosh.com'
  end
end
