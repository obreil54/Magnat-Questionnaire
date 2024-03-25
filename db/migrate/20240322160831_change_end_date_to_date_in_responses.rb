class ChangeEndDateToDateInResponses < ActiveRecord::Migration[7.1]
  def change
    change_column :responses, :end_date, :datetime
  end
end
