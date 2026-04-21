class User < ApplicationRecord
  # Valida que o nome não pode ficar em branco
  validates :name, presence: true
  # Valida que o email é obrigatório e único na base de dados
  validates :email, presence: true, uniqueness: true

  def google_calendar_service
    GoogleCalendarService.new(self)
  end
end
