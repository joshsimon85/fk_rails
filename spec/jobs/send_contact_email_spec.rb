require 'spec_helper'

RSpec.describe SendContactEmailJob, :type => :job do
  it 'sends an email to the admin' do
    ActiveJob::Base.queue_adapter = :test
    expect {
      SendContactEmailJob.perform_later('admin', 1)
    }.to have_enqueued_job
  end

  it 'sends an email to the user' do

  end
end
