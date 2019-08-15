
require 'rails_helper'

RSpec.describe JobPublisher, type: :model do
  describe "#call" do
    it "sets up published_at to current time" do 
      job = create(:job)

      JobPublisher.new(job).call

      expect(job.reload.published_at).to_not be_nil
    end

    it "sends summary email to job's creator" do
      job = create(:job, email: 'marcin@rubyjobs.pl')

      JobPublisher.new(job).call

      expect(ActionMailer::Base.deliveries.last.to).to eq ['marcin@rubyjobs.pl']
    end
  end
end
