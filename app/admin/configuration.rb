ActiveAdmin.register Configuration do
  permit_params :key, :value

  form do |f|
    f.inputs do
      f.input :key, label: 'Key'
      f.input :value, label: 'Value', as: :string,
        input_html: { value: f.object.new_record? ? '{}' : f.object.value.to_json },
        hint: 'eg: {"value":12}'
    end

    f.actions
  end

  index do
    column :id
    column :key
    column :value do |config|
      JSON.dump(config.value)
    end

    actions
  end

  show do |config|
    attributes_table do
      row :id
      row :key
      row :value do
        JSON.dump(config.value)
      end
    end
  end
end
