ActiveAdmin.register PaySlip do
  permit_params :month, :year, :file

  actions :all, except: [:edit, :update, :destroy]

  controller do
    def create
      pay_slip_params = params.require(:pay_slip).permit(:month, :year, :file)
      pay_slip = PaySlip.new(pay_slip_params)
      pay_slip.admin_user = current_admin_user

      if pay_slip.save
        flash.notice = "Payslips are being generated and will be sent to all associates"
        redirect_to admin_pay_slips_url
      else
        flash.alert = pay_slip.errors.full_messages.to_sentence
        redirect_to new_admin_pay_slip_url
      end
    end
  end

  form do |f|
    f.inputs "Generate new PaySlips" do
      f.input :month, as: :select, collection: Date::MONTHNAMES.reject(&:nil?)
      f.input :year, as: :select, collection: ((Date.today.year - 10)..Date.today.year).to_a.reverse
      f.input :file, as: :file, hint: "Please make sure 'Associate number' and 'Days paid' columns are added to the excel before sending salary slips"

      f.actions
    end
  end
end
