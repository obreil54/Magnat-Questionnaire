class RemoveLoanedAtFromHardwares < ActiveRecord::Migration[7.1]
  def change
    remove_column :hardwares, :loaned_at, :datetime
  end
end
