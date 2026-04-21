class FullMoonEventService
  def initialize(user, moon_data)
    @user = user
    @moon_data = moon_data
  end

  def schedule_full_moon_event
    return unless @user.google_calendar_enabled?
    return unless future_full_moon_date

    services = GoogleCalendarService.new(@user)
    services.add_full_moon_event(@moon_data, future_full_moon_date)
  end

  private

  def future_full_moon_date
    return nil unless @moon_data.days_until_full_moon.is_a?(Integer)
    return nil if @moon_data.days_until_full_moon <= 0

    (Date.current + @moon_data.days_until_full_moon.days).at_beginning_of_day
  end
end
