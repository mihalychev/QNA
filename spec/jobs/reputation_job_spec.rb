require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { build :question }

  it 'calls Reputation#calculate' do
    expect(Reputation).to receive(:calculate).with(question)
    ReputationJob.perform_now(question)
  end
end
