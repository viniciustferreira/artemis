class MoonData::Index < MoonData::Base
  def present
    {
      phase: translate_phase(@moon_data[:phase][:name]),
      sign: translate_sign(@moon_data[:zodiac][:sign]),
      special_moon: translate_special_moon(@moon_data[:special_moon]),
      days_until_full_moon: days_until(:full_moon),
      days_until_new_moon: days_until(:new_moon),
      api_response: @moon_data,
      latitude: @latitude,
      longitude: @longitude
    }
  end

  private

  def days_until(type)
    moon = @moon_data[:next_phases] && @moon_data[:next_phases][type]
    return 0 unless moon

    (@moon_data[:next_phases][type].to_date - Date.current).to_i
  end
end
