require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { login(user) }
      
      context 'with valid attributes' do
        it 'saves a new answer in the database' do        
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }, format: :js }.to change(question.answers, :count).by(1)
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }, format: :js }.to change(user.answers, :count).by(1) 
        end
  
        it 'renders create template' do
          post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, user_id: user }, format: :js }.to_not change(Answer, :count) 
        end
        
        it 'renders create template' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, user_id: user }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'tries create answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Authenticated user', js: true do
      before { login(user) }
      
      let!(:answer) { create(:answer, question: question) }
  
      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer  
        end
  
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          answer.reload
          expect(answer.body).to eq 'new body'
        end
  
        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end
  
      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }
  
        it 'does not change answer' do
          answer.reload
          expect(answer.body).to eq answer.body
        end
  
        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'tries to change answer' do
        patch :update, params: { id: answer,  answer: attributes_for(:answer) }
        expect(assigns(:answer)).not_to eq answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'Authenticated user', js: true do
      let!(:answer) { create(:answer, question: question, user: user) }
  
      context 'author' do
        before { login(user) }
    
        it 'tries to delete the answer' do
          expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(user.answers, :count).by(-1)
        end
    
        it 'renders destroy view' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end
  
      context 'not author' do
        before { login(user2) }
  
        it 'tries to delete the answer' do
          expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to_not change(Answer, :count)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    describe 'Unauthenticated user' do
      let!(:answer) { create(:answer) }

      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
