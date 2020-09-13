require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double('NewAnswerService') }
  let(:answer) { create :answer }

  before do
    allow(NewAnswerService).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerService#notify' do
    expect(service).to receive(:notify)
    NewAnswerJob.perform_now(answer)
  end
end
