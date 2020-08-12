require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user) }

  let!(:question_file) { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }
  let!(:answer_file) { answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }
  
  describe 'DELETE #destroy' do
    describe 'Authenticated user' do
      context 'author' do
        before { login(user) }
      
        it 'tries to delete file' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)
        end
      end

      context 'not author' do
        before { login(user2) }

        it 'tries to delete file' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
        end
      end
    end

    it 'Unauthenticated user tries to delete file' do
      expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
    end
  end
end