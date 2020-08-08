require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe '#set_best' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it 'marks the answer as best' do
      answer.set_best
      expect(answer).to be_best
    end

    it 'sets another answers best attribute to false' do
      create_list(:answer, 3, question: question, best: true)
      answer.set_best
      expect(question.answers.where(best: true).count).to eq 1
      expect(question.answers.find_by(id: answer)).to be_best
    end
  end
end
