class GoogleCalendarAuthController < ApplicationController
  def authorize
    user = User.find(params[:user_id])
    service = GoogleCalendarService.new(user)
    
    redirect_to service.get_authorization_url, allow_other_host: true
  end

  def callback
    user = User.find(params[:user_id])
    code = params[:code]
    
    if code.present?
      service = GoogleCalendarService.new(user)
      
      begin
        service.handle_callback(code)
        redirect_to root_path, notice: "Google Calendar conectado com sucesso!"
      rescue StandardError => e
        Rails.logger.error("Google Calendar callback error: #{e.message}")
        redirect_to root_path, alert: "Erro ao conectar Google Calendar: #{e.message}"
      end
    else
      redirect_to root_path, alert: "Autorização cancelada"
    end
  end

  def disconnect
    user = User.find(params[:user_id])
    user.update(
      google_calendar_enabled: false,
      google_calendar_token: nil,
      google_calendar_refresh_token: nil,
      google_calendar_token_expires_at: nil
    )
    
    redirect_to root_path, notice: "Google Calendar desconectado com sucesso!"
  end
end
