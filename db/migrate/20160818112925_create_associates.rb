class CreateAssociates < ActiveRecord::Migration[5.0]
  def change
    create_table :associates do |t|
      t.string :associate_number
      t.string :title
      t.string :full_name
      t.string :email
      t.string :designation
      t.string :pan_number
    end
  end
end
