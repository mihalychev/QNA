# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:question) { create(:question, user: user) }

    context 'valid' do
      it 'compares user and author' do
        expect(user).to be_author_of(question)
      end
    end

    context 'invalid' do
      it 'compares user and author' do
        expect(user2).to_not be_author_of(question)
      end
    end
  end
end
