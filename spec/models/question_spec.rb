# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/models/concerns/votable_spec.rb')
require Rails.root.join('spec/models/concerns/commentable_spec.rb')

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe 'associations' do
    it { should belong_to :user }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#with_best_answer?' do
    let(:question) { create :question }
    let(:answer) { create :answer, best: true }
    let(:question_with_best_answer) { create :question, answers: [answer] }

    context 'without best answer' do
      it 'returns false' do
        expect(question_with_best_answer.with_best_answer?).to eq true
      end
    end

    context 'with best answer' do
      it 'returns true' do
        expect(question.with_best_answer?).to eq false
      end
    end
  end

  describe '#created_time' do
    let!(:question) { create :question, created_at: Time.parse('2021-08-1T12:00:00Z') }

    it 'returns created time with format hh:mm' do
      expect(question.created_time).to eq '12:00'
    end
  end

  describe '#created_date' do
    let(:question) { create :question, created_at: Time.parse('2021-08-1T12:00:00Z') }

    it 'returns created date with format dd:mm:yy' do
      expect(question.created_date).to eq '01.08.2021'
    end
  end
end
