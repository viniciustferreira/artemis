namespace :cron do
  desc "Enqueue daily lunar email job"
  task daily_lunar_email: :environment do
    # Enqueue the job to generate moon data and send daily emails to users.
    # Uses ActiveJob adapter configured in the environment (Sidekiq, async, etc.).
    puts "Starting DailyLunarEmailJob..."
    # If a DATABASE_URL is present, ensure ActiveRecord connects to it.
    if ENV["DATABASE_URL"]
      begin
        puts "Establishing DB connection from DATABASE_URL"
        ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])
        # touch the connection to raise early if it fails
        ActiveRecord::Base.connection
        puts "Connected to database via DATABASE_URL"
      rescue => e
        puts "ERROR: failed to connect using DATABASE_URL: #{e.class}: #{e.message}"
        raise
      end
    end

    # Run the job synchronously so a one-off rake invocation actually executes the work
    DailyLunarEmailJob.perform_now
    puts "DailyLunarEmailJob complete."
  end
end
