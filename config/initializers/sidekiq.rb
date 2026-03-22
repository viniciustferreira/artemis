require "sidekiq"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }

  # Load sidekiq-cron schedule if present
  schedule_file = Rails.root.join("config/sidekiq_scheduler.yml")
  if schedule_file.exist? && defined?(Sidekiq::Cron)
    begin
      schedule = YAML.load_file(schedule_file)
      Sidekiq::Cron::Job.load_from_hash!(schedule) if schedule
    rescue => e
      Rails.logger.warn("Sidekiq cron schedule load failed: #{e.message}")
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0") }
end
