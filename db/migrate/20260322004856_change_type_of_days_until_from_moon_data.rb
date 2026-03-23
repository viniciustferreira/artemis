class ChangeTypeOfDaysUntilFromMoonData < ActiveRecord::Migration[8.1]
  def change
    change_column :moon_data, :days_until_full_moon, :integer
    change_column :moon_data, :days_until_new_moon, :integer
  end
end
