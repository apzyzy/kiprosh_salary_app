class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  private

  def attach_pay_slip(obj)
    name = obj.associate.full_name

    WickedPdf.new.pdf_from_string(
      render_to_string(
        pdf: "#{name}",
        template: 'pay_slip_mailer/pay_slip_template.haml',
        layout: 'mailer.html.erb',
        locals: { obj: obj }
      )
    )
  end
end
