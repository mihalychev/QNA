require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[ title body user_id created_at updated_at ].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create :question }
    let!(:question_file) { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question_response) { json['question'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token, id: question.id }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do        
        %w[ title body user_id comments links created_at updated_at ].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'return attached files' do
        expect(question_response['files'].size).to eq 1 
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      
      context 'with valid attributes' do
        let(:request) { post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers }
        
        it 'returns 200 status' do
          request
          expect(response).to be_successful
        end
  
        it 'saves new question in database' do
          expect { request }.to change(Question, :count).by(1)
        end
  
        it 'returns all public fields' do
          request    
          %w[ title body user_id comments links created_at updated_at ].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        let(:request) { post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers }

        it 'returns unprocessable entity status' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not create question' do
          expect { request }.to_not change(Question, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }

      context 'with valid attributes' do
        before { patch api_path, params: { access_token: access_token.token, id: question, question: { title: 'new title', body: 'new body' } }, headers: headers }
  
        it 'returns 200 status' do
          expect(response).to be_successful
        end
  
        it 'updates question' do
          %w[ title body ].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        let(:request) { patch api_path, params: { access_token: access_token.token, id: question, question: { title: '', body: '' } }, headers: headers }

        it 'returns unprocessable entity status' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not change question attributes' do
          expect { request }.to_not change(question, :title)
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'author' do
        let(:request) { delete api_path, params: { access_token: access_token.token, id: question } }

        it 'deletes question' do
          expect { request }.to change(Question, :count).by(-1)
        end
      end

      context 'not author' do
        let(:request) { delete api_path, params: { access_token: other_access_token.token, id: question } }

        it 'does not delete question' do
          expect { request }.to_not change(Question, :count)
        end
      end
    end
  end
end