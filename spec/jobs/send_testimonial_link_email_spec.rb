require 'rails_helper'

RSpec.describe SendTestimonialLinkEmailJob do
  it 'enqueues a testimonai link job with the users id' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      SendTestimonialLinkEmailJob.perform_later(1)
    }.to have_enqueued_job.with(1)
  end
end
