require "rails_helper"

describe FullMoonEventService do
  let(:user) { create(:user, google_calendar_enabled: true) }
  let(:moon_data) { create(:moon_data, days_until_full_moon: 5) }
  let(:service) { described_class.new(user, moon_data) }

  describe "#schedule_full_moon_event" do
    context "when user has google calendar enabled" do
      it "calls GoogleCalendarService to add event" do
        google_service_mock = instance_double(GoogleCalendarService)
        allow(GoogleCalendarService).to receive(:new).and_return(google_service_mock)
        allow(google_service_mock).to receive(:add_full_moon_event)
        
        service.schedule_full_moon_event
        
        expect(google_service_mock).to have_received(:add_full_moon_event)
      end
    end

    context "when user does not have google calendar enabled" do
      before { user.update(google_calendar_enabled: false) }

      it "does not call GoogleCalendarService" do
        google_service_mock = instance_double(GoogleCalendarService)
        allow(GoogleCalendarService).to receive(:new).and_return(google_service_mock)
        allow(google_service_mock).to receive(:add_full_moon_event)
        
        service.schedule_full_moon_event
        
        expect(google_service_mock).not_to have_received(:add_full_moon_event)
      end
    end

    context "when days until full moon is not an integer" do
      before { moon_data.update(days_until_full_moon: nil) }

      it "does not schedule event" do
        expect(GoogleCalendarService).not_to receive(:new)
        
        service.schedule_full_moon_event
      end
    end

    context "when days until full moon is in the past" do
      before { moon_data.update(days_until_full_moon: -1) }

      it "does not schedule event" do
        expect(GoogleCalendarService).not_to receive(:new)
        
        service.schedule_full_moon_event
      end
    end
  end
end
