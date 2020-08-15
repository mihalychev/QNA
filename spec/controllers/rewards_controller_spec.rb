require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  
  describe 'GET #index' do
    let(:rewards) { create_list(:reward, 3, user: user, question: question) }

    before { login(user) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end