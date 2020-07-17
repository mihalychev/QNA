require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do

    it 'renders new view' do
      get :new, params: { question_id: question }
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    let(:answer) { create(:answer, question: question) }

    it 'renders edit view' do
      get :edit, params: { id: answer, question_id: question }
      expect(response).to render_template :edit
    end
  end

end
