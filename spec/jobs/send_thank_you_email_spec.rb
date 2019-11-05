require 'rails_helper'

RSpec.describe SendThankYouEmailJob do
  it 'enqueues a send thank you email job with the user type as admin and an id' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      SendThankYouEmailJob.perform_later('admin', 1)
    }.to have_enqueued_job.with('admin', 1)
  end

  it 'enqueues a send thank you email job with the user type as user and an id' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      SendThankYouEmailJob.perform_later('user', 2)
    }.to have_enqueued_job.with('user', 2)
  end

  it 'creates a record with error details' do
    SendThankYouEmailJob.perform_now('user', 2)
    expect(Report.count).to eq(1)
    expect(Report.first.error_type).to eq('Record Not Found')
    expect(Report.first.message).to eq("Couldn't find User with 'id'=2")
  end
end
