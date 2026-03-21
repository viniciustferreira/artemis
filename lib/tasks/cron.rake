namespace :cron do
  desc "Enqueue daily lunar email job"
  task daily_lunar_email: :environment do
    # Enqueue the job to generate moon data and send daily emails to users.
    # Uses ActiveJob adapter configured in the environment (Sidekiq, async, etc.).
    puts "Starting DailyLunarEmailJob..."
    # Run the job synchronously so a one-off rake invocation actually executes the work
    DailyLunarEmailJob.perform_now
    puts "DailyLunarEmailJob complete."
  end
end
