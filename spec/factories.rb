FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { "user#{rand(1000)}@example.com" }
    latitude { -23.5505 }
    longitude { -46.6333 }
    google_calendar_enabled { false }
    google_calendar_token { nil }
    google_calendar_refresh_token { nil }
    google_calendar_token_expires_at { nil }
  end

  factory :moon_data do
    latitude { -23.5505 }
    longitude { -46.6333 }
    phase { "Wanning Gibbous" }
    sign { "Aquarius" }
    special_moon { nil }
    days_until_full_moon { 5 }
    days_until_new_moon { 13 }
    api_response do
      {
        "phase" => "Wanning Gibbous",
        "illumination" => 75.5,
        "days_until_full_moon" => 5,
        "days_until_new_moon" => 13,
        "zodiac" => "Aquarius",
        "special_moon" => nil
      }
    end
  end
end
