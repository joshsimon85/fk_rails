class SentryJob < ActiveJob::Base
  queue_as :sentry_reports

  def perform(event)
    Raven.send_event(event)
  end
end
