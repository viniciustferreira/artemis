# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

## How to run the daily lunar email

To enqueue the daily lunar email job immediately:

    bin/rails cron:daily_lunar_email

Or with rake/bundle in any environment:

    bundle exec rake cron:daily_lunar_email RAILS_ENV=production

Notes:

- The mailer and job use the Rails `ActionMailer` and `ActiveJob` settings in your environment files.
- If you want a production scheduler, run Sidekiq with a scheduler (config/sidekiq_scheduler.yml and config/sidekiq.yml exist) or use system cron / Windows Task Scheduler to run the rake task daily.
