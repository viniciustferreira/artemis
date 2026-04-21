class AddGoogleCalendarToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :google_calendar_enabled, :boolean, default: false
    add_column :users, :google_calendar_token, :text
    add_column :users, :google_calendar_refresh_token, :text
    add_column :users, :google_calendar_token_expires_at, :datetime
    add_index :users, :email, unique: true
  end
end
