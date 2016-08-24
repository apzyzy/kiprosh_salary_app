class CreatePaySlips < ActiveRecord::Migration[5.0]
  def change
    create_table :pay_slips do |t|
      t.string     :month
      t.integer    :year
      t.references :admin_user
      t.timestamps
    end
  end
end
