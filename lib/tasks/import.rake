require 'activerecord-import'

namespace :import do
  desc "Imports associates details and save them to Associate table"
  task :associates_from_remote_csv, [:url] => :environment do |t, args|
    file = open(args[:url]).read
    all_associates = Associate.all

    values = []
    columns = [:associate_number, :title, :full_name, :email, :designation, :pan_number]

    CSV.parse(file, headers: true).each do |row|
      row_values = row.fields
      unless all_associates.where(associate_number: row_values[0]).any?
        values << row_values
      end
    end

    Associate.import columns, values, validate: false
  end
end
