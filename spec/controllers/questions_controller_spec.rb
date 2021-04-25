# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/controllers/concerns/voted_spec.rb')

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:user2) { create(:user) }
  let(:category) { create(:category) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answer) { create(:answer) }
    before { get :show, params: { id: question } }

    it 'check link' do
      expect(assigns(:answer).links.first).to be_a_new Link
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    describe 'Authenticated user' do
      before { login(user) }
      before { get :new }

      it 'check question' do
        expect(assigns(:question)).to be_a_new Question
      end

      it 'check link' do
        expect(assigns(:question).links.first).to be_a_new Link
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe 'Unauthenticated user' do
      before { get :new }

      it 'guest tries to render new view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    describe 'Authenticated user' do
      subject(:params) do
        { params: { question: attributes_for(:question).merge(category_id: category.id) } }
      end
      subject(:params_invalid) do
        { params: { question: attributes_for(:question, :invalid) } }
      end

      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params }.to change(user.questions, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params_invalid }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params_invalid
          expect(response).to render_template :new
        end
      end
    end

    describe 'Unauthenticated user' do
      subject(:params) do
        { params: { question: attributes_for(:question) } }
      end

      it 'does not save a new question in the database' do
        expect { post :create, params }.not_to change(Question, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    subject(:params) do
      { params: { id: question, question: attributes_for(:question) }, format: :js }
    end
    subject(:params_invalid) do
      { params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
    end

    describe 'Authenticated user' do
      context 'author' do
        before { login(user) }

        context 'with valid attributes' do
          it 'assigns the requested question to @question' do
            patch :update, params
            expect(assigns(:question)).to eq question
          end

          it 'changes question attributes' do
            params = { params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js } }
            patch :update, params
            question.reload

            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'redirects to updated question' do
            patch :update, params
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before { patch :update, params_invalid }

          it 'does not change question' do
            question.reload
            expect(question.title).to eq question.title
            expect(question.body).to eq question.body
          end

          it 're-renders edit view' do
            expect(response).to render_template :update
          end
        end
      end

      context 'not author' do
        before { login(user2) }

        it 'does not change question' do
          patch :update, params
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'tries to change question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).not_to eq question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'Authenticated user' do
      let!(:question) { create(:question, user: user) }

      context 'author' do
        before { login(user) }

        it 'tries to delete the question' do
          expect { delete :destroy, params: { id: question } }.to change(user.questions, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'not author' do
        before { login(user2) }

        it 'tries to delete question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end
      end
    end

    describe 'Unauthenticated user' do
      let!(:question) { create(:question) }

      it 'tries to delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
