require "google/apis/calendar_v3"
require "googleauth/stores/file_token_store"
require "googleauth/user_authorizer"

class GoogleCalendarService
  def initialize(user)
    @user = user
    @calendar = Google::Apis::CalendarV3::CalendarService.new
  end

  def authorize
    @calendar.authorization = authorizer.get_credentials(@user.email)
  end

  def add_full_moon_event(moon_data, date)
    return unless @user.google_calendar_enabled?

    authorize

    event = Google::Apis::CalendarV3::Event.new(
      summary: "🌕 Lua Cheia #{moon_data.special_moon&.titleize || 'Cheia'}",
      description: build_event_description(moon_data),
      start: Google::Apis::CalendarV3::EventDateTime.new(date: date),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: date + 1.day),
      all_day: true,
      transparency: "transparent"
    )

    begin
      @calendar.insert_event("primary", event)
      Rails.logger.info("✓ Full moon event created for #{@user.email} on #{date}")
    rescue Google::Apis::AuthorizationError => e
      Rails.logger.error("Google Calendar authorization error: #{e.message}")
      # Token may be expired, clear it
      @user.update(google_calendar_enabled: false)
    rescue StandardError => e
      Rails.logger.error("Failed to create event: #{e.message}")
    end
  end

  def get_authorization_url
    authorizer.authorization_uri.to_s
  end

  def handle_callback(code)
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: @user.email,
      code: code,
      base_url: Rails.application.routes.url_helpers.root_url
    )
    @user.update(
      google_calendar_enabled: true,
      google_calendar_token: credentials.access_token,
      google_calendar_refresh_token: credentials.refresh_token,
      google_calendar_token_expires_at: Time.at(credentials.expires_at)
    )
  end

  private

  def build_event_description(moon_data)
    description = "Lua na fase #{moon_data.phase}"
    description += " - #{moon_data.sign} (Zodíaco)" if moon_data.sign.present?
    description += " - #{moon_data.special_moon.humanize}" if moon_data.special_moon.present?
    description
  end

  def authorizer
    client_id = Google::Auth::ClientId.from_file(credentials_path)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: token_path)
    
    Google::Auth::UserAuthorizer.new(
      client_id,
      ["https://www.googleapis.com/auth/calendar"],
      token_store,
      default_user_id: @user.email
    )
  end

  def credentials_path
    Rails.root.join("config", "google_client_secret.json")
  end

  def token_path
    Rails.root.join("tmp", "google_calendar_token_#{@user.email}.yaml")
  end
end
