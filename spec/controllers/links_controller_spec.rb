require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user) }
  let!(:link) { create(:link, linkable: question) }
  let!(:link2) { create(:link, linkable: answer) }
  
  describe 'DELETE #destroy' do
    describe 'Authenticated user' do
      context 'author' do
        before { login(user) }
      
        it 'tries to delete link' do
          expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
          expect { delete :destroy, params: { id: link2 }, format: :js }.to change(answer.links, :count).by(-1)
        end
      end

      context 'not author' do
        before { login(user2) }

        it 'tries to delete link' do
          expect { delete :destroy, params: { id: link }, format: :js }.to_not change(question.links, :count)
          expect { delete :destroy, params: { id: link2 }, format: :js }.to_not change(answer.links, :count)
        end
      end
    end

    it 'Unauthenticated user tries to delete link' do
      expect { delete :destroy, params: { id: link }, format: :js }.to_not change(question.links, :count)
      expect { delete :destroy, params: { id: link2 }, format: :js }.to_not change(answer.links, :count)
    end
  end
end