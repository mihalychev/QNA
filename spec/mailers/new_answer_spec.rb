# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswerMailer, type: :mailer do
  describe 'new answer' do
    let(:user) { create :user }
    let(:answer) { create :answer }
    let(:mail) { NewAnswerMailer.notify(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notify')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("New answer for question: #{answer.question.title}")
    end
  end
end
