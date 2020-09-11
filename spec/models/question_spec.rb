require 'rails_helper'
require Rails.root.join("spec/models/concerns/votable_spec.rb")
require Rails.root.join("spec/models/concerns/commentable_spec.rb")

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
  
  describe 'associations' do
    it { should belong_to :user }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_one(:reward).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }  
  end

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build :question }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
