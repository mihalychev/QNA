require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:user2) { create(:user) }

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
    before { get :show, params: { id: question } }

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
      before { login(user) }
  
      context 'with valid attributes' do
        it 'saves a new question in the database' do        
          expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1) 
        end
  
        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end
  
      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count) 
        end
        
        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'does not save a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.not_to change(Question, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Authenticated user' do
      context 'author' do
        before { login(user) }
        
        context 'with valid attributes' do
          it 'assigns the requested question to @question' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(assigns(:question)).to eq question  
          end
          
          it 'changes question attributes' do
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
            question.reload
    
            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end
    
          it 'redirects to updated question' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(response).to render_template :update
          end
        end
    
        context 'with invalid attributes' do
          before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }
    
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
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end
        
        it 'returns a :forbidden status code' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to have_http_status(:forbidden)  
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'tries to change question' do
        patch :update, params: { id: question,  question: attributes_for(:question) }
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
        
        it 'returns a :forbidden status code' do
          delete :destroy, params: { id: question }
          expect(response).to have_http_status(:forbidden)  
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
