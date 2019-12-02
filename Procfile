web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -t 25 -c 2 -q mailers -q sentry_reports -q default
