require 'rails_helper'

RSpec.describe SendTestimonialLinkEmailJob do
  it 'enqueues a testimonai link job with the users id' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      SendTestimonialLinkEmailJob.perform_later(1)
    }.to have_enqueued_job.with(1)
  end

  it 'creates a record with error information when the user does not exist' do
    SendTestimonialLinkEmailJob.perform_now(10)
    expect(Report.count).to eq(1)
    expect(Report.first.error_type).to eq('Record Not Found')
    expect(Report.first.message).to eq("Couldn't find User with 'id'=10")
  end
end
