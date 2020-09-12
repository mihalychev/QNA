require 'rails_helper'

RSpec.describe NewAnswerService do
  let(:author) { create(:user) }
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question) }

  before do
    users.each { |user| create(:subscription, question: question, user: user) }
  end

  it 'sends new answer notice to users' do
    expect(NewAnswerMailer).to receive(:notify).with(author, answer).and_call_original
    users.each { |user| expect(NewAnswerMailer).to receive(:notify).with(user, answer).and_call_original }
    subject.notify(answer)
  end
end