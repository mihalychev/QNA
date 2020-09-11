require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double('NewAnswer') }
  let(:answer) { create :answer }

  before do
    allow(NewAnswer).to receive(:new).and_return(service)
  end

  it 'calls NewAnswer#notify' do
    expect(service).to receive(:notify)
    NewAnswerJob.perform_now(answer)
  end
end
