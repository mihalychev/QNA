# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:answer_comment)   { create :comment, :for_answer }
  let(:question_comment) { create :comment, :for_question }

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :commentable }
  end

  describe 'validations' do
    context 'when for answer' do
      it 'is valid with valid attributes' do
        expect(answer_comment).to be_valid
      end

      context 'body length' do
        it 'is not valid when more than 200' do
          answer_comment.body = (0..200).map { '1' }.join
          answer_comment.valid?
          expect(answer_comment.errors[:body]).to eq ['is too long (maximum is 200 characters)']
        end

        it 'can not be 0' do
          answer_comment.body = ''
          answer_comment.valid?
          expect(answer_comment.errors[:body]).to eq ["can't be blank"]
        end
      end
    end

    context 'when for question' do
      it 'is valid with valid attributes' do
        expect(question_comment).to be_valid
      end

      context 'body length' do
        it 'is not valid when more than 200' do
          question_comment.body = (0..200).map { '1' }.join
          question_comment.valid?
          expect(question_comment.errors[:body]).to eq ['is too long (maximum is 200 characters)']
        end

        it 'can not be 0' do
          question_comment.body = ''
          question_comment.valid?
          expect(question_comment.errors[:body]).to eq ["can't be blank"]
        end
      end
    end

    it { should validate_presence_of(:body) }
  end
end
