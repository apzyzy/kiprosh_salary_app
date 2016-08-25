ActiveAdmin.register Associate do
  permit_params :associate_number, :designation, :email, :full_name,
                :pan_number, :title

  config.sort_order = 'associate_number_asc'

  index do
    column :associate_number
    column :title
    column :full_name
    column :email
    column :designation
    column('PAN Number', &:pan_number)
    actions
  end

  form do |f|
    f.inputs "Associate details" do
      f.input :associate_number
      f.input :title, as: :select, collection: %w(Ms Mr Mrs)
      f.input :full_name
      f.input :email
      f.input :designation
      f.input :pan_number, label: 'PAN number'
    end

    f.actions
  end
end
