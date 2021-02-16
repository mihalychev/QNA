# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create :user }
  let!(:question) { create :question }

  describe 'POST #create' do
    subject(:params) { { params: { question_id: question }, format: :js } }

    context 'authenticated user' do
      before { login user }

      it 'creates subscription' do
        expect { post :create, params }.to change(user.subscriptions, :count).by(1)
      end
    end

    context 'unauthenticated user' do
      it 'does not create subscription' do
        expect { post :create, params }.to_not change(user.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:params) { { params: { id: question }, format: :js } }

    let!(:subscription) { create(:subscription, user: user, question: question) }

    context 'authenticated user' do
      before { login user }

      it 'deletes subscription' do
        expect { delete :destroy, params }.to change(user.subscriptions, :count).by(-1)
      end
    end

    context 'unauthenticated user' do
      it 'does not delete subscription' do
        expect { delete :destroy, params }.to_not change(user.subscriptions, :count)
      end
    end
  end
end
