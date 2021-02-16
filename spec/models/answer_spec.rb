require 'rails_helper'
require Rails.root.join("spec/models/concerns/votable_spec.rb")
require Rails.root.join("spec/models/concerns/commentable_spec.rb")

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe 'associations' do    
    it { should belong_to :question }
    it { should belong_to :user }
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#toggle_best' do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: user2) }

    it 'marks the answer as best' do
      answer.toggle_best
      expect(answer).to be_best
    end

    it 'sets another answers best attribute to false' do
      create_list(:answer, 3, question: question, best: true)
      answer.toggle_best
      expect(question.answers.where(best: true).count).to eq 1
      expect(question.answers.find_by(id: answer)).to be_best
    end
  end
end
