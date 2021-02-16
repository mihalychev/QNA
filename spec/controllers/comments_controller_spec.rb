# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        subject(:question_params) do
          { params: { comment: attributes_for(:comment), question_id: question }, format: :js }
        end
        subject(:answer_params) do
          { params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }
        end

        it 'adds a new comment to question' do
          expect { post :create, question_params }.to change(question.comments, :count).by(1)
          expect { post :create, question_params }.to change(user.comments, :count).by(1)
        end

        it 'adds a new comment to answer' do
          expect { post :create, answer_params }.to change(answer.comments, :count).by(1)
          expect { post :create, answer_params }.to change(user.comments, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        subject(:invalid_question_comment_params) do
          { params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }
        end
        subject(:invalid_answer_comment_params) do
          { params: { comment: attributes_for(:comment, :invalid), answer_id: answer }, format: :js }
        end

        it 'does not save the comment' do
          expect { post :create, invalid_question_comment_params }.to_not change(Comment, :count)
          expect { post :create, invalid_answer_comment_params }.to_not change(Comment, :count)
        end
      end
    end

    describe 'Unauthenticated user' do
      subject(:question_comment_params) do
        { params: { comment: attributes_for(:comment), question_id: question } }
      end
      subject(:answer_comment_params) do
        { params: { comment: attributes_for(:comment), answer_id: answer } }
      end

      it 'tries create comment' do
        expect { post :create, question_comment_params }.to_not change(Comment, :count)
        expect { post :create, answer_comment_params }.to_not change(Comment, :count)
      end
    end
  end
end
