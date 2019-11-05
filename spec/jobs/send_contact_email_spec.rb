require 'rails_helper'

RSpec.describe SendContactEmailJob do
  it 'enqueues an admin email job' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      SendContactEmailJob.perform_later('admin', 1)
    }.to have_enqueued_job.with('admin', 1)
  end

  it 'enqueues a user email job' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      SendContactEmailJob.perform_later('user', 2)
    }.to have_enqueued_job.with('user', 2)
  end
end
