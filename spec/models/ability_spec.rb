require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Link }
    it { should be_able_to :read, Vote }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :admin }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:answer) { create(:answer, user: user) }
    let(:other_answer) { create(:answer, user: other_user) }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :me, User }

    context 'question' do
      it { should be_able_to :create, Question }
      
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, other_question }

      it { should_not be_able_to :vote_up, question }
      it { should be_able_to :vote_up, other_question }

      it { should_not be_able_to :vote_down, question }
      it { should be_able_to :vote_down, other_question }

      it { should_not be_able_to :unvote, question }
      it { should be_able_to :unvote, other_question }
    end

    context 'answer' do
      it { should be_able_to :create, Answer }
      
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }
    
      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, other_answer }

      it { should_not be_able_to :vote_up, answer }
      it { should be_able_to :vote_up, other_answer }

      it { should_not be_able_to :vote_down, answer }
      it { should be_able_to :vote_down, other_answer }

      it { should_not be_able_to :unvote, answer }
      it { should be_able_to :unvote, other_answer }

      it { should be_able_to :best, create(:answer, question: question) }
      it { should_not be_able_to :best, create(:answer, question: other_question) }
    end

    context 'attachment' do
      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        other_question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        other_answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end

      it { should be_able_to :destroy, answer.files.first }
      it { should_not be_able_to :destroy, other_answer.files.first }

      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, other_question.files.first }
    end

    context 'comment' do
      it { should be_able_to :create, Comment }
    end

    context 'link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
    end
  end
end