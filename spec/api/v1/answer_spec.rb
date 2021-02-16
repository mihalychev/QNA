# frozen_string_literal: true

require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }
  let!(:question) { create(:question, user: user) }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token, question_id: question }, headers: headers }

      it_behaves_like 'Success Status'

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answer/:id' do
    let(:answer) { create(:answer, question: question) }
    let!(:answer_file) do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    end
    let(:api_path) { api_v1_answer_path(answer) }
    let(:answer_response) { json['answer'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token, id: answer.id }, headers: headers }

      it_behaves_like 'Success Status'

      it 'returns all public fields' do
        %w[body user_id comments links created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'return attached files' do
        expect(answer_response['files'].size).to eq 1
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    let(:answer_response) { json['answer'] }

    context 'with valid attributes' do
      subject(:params) do
        {
          params: {
            access_token: access_token.token,
            answer: attributes_for(:answer),
            question_id: question,
            headers: headers
          }
        }
      end
      let(:request) { post api_path, params }

      it_behaves_like 'Success Status' do
        before { request }
      end

      it 'saves new answer in database' do
        expect { request }.to change(Answer, :count).by(1)
      end

      it 'returns all public fields' do
        request
        %w[body user_id comments links created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
        end
      end
    end

    context 'with invalid attributes' do
      subject(:params) do
        { params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid), headers: headers } }
      end
      let(:request) { post api_path, params }

      it 'returns unprocessable entity status' do
        request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create answer' do
        expect { request }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      context 'with valid attributes' do
        subject(:params) do
          { params: { access_token: access_token.token, id: answer, answer: { body: 'new body' }, headers: headers } }
        end
        before { patch api_path, params }

        it_behaves_like 'Success Status'

        it 'updates answer' do
          %w[body].each do |attr|
            expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        subject(:params) do
          { params: { access_token: access_token.token, id: answer, answer: { body: '' }, headers: headers } }
        end
        let(:request) { patch api_path, params }

        it 'returns unprocessable entity status' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change question attributes' do
          expect { request }.to_not change(answer, :body)
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'author' do
        let(:request) { delete api_path, params: { access_token: access_token.token, id: answer } }

        it 'deletes answer' do
          expect { request }.to change(Answer, :count).by(-1)
        end
      end

      context 'not author' do
        let(:request) { delete api_path, params: { access_token: other_access_token.token, id: answer } }

        it 'does not delete answer' do
          expect { request }.to_not change(Answer, :count)
        end
      end
    end
  end
end
