require "rails_helper"

RSpec.describe GoogleCalendarAuthController, type: :controller do
  let(:user) { create(:user) }

  describe "POST #authorize" do
    it "redirects to Google authorization URL" do
      google_service_mock = instance_double(GoogleCalendarService)
      allow(GoogleCalendarService).to receive(:new).and_return(google_service_mock)
      allow(google_service_mock).to receive(:get_authorization_url).and_return("https://oauth.example.com")
      
      post :authorize, params: { user_id: user.id }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #callback" do
    context "with valid authorization code" do
      it "updates user with google calendar credentials" do
        google_service_mock = instance_double(GoogleCalendarService)
        allow(GoogleCalendarService).to receive(:new).and_return(google_service_mock)
        allow(google_service_mock).to receive(:handle_callback)
        
        get :callback, params: { user_id: user.id, code: "valid_code" }
        
        expect(response).to redirect_to(root_path)
      end
    end

    context "without authorization code" do
      it "shows error message" do
        get :callback, params: { user_id: user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/cancelada/)
      end
    end
  end

  describe "DELETE #disconnect" do
    before { user.update(google_calendar_enabled: true) }

    it "disables google calendar for user" do
      delete :disconnect, params: { user_id: user.id }
      
      user.reload
      expect(user.google_calendar_enabled).to be(false)
      expect(response).to redirect_to(root_path)
    end

    it "clears google calendar tokens" do
      delete :disconnect, params: { user_id: user.id }
      
      user.reload
      expect(user.google_calendar_token).to be_nil
      expect(user.google_calendar_refresh_token).to be_nil
    end
  end
end
