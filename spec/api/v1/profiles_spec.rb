require 'rails_helper'

describe 'Profile API', type: :request do
  let(:headers) { { 
    "CONTENT_TYPE" => "application/json",
    "ACCEPT"       => "application/json" 
  } }

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:profiles) { create_list(:user, 3) }
      let(:me) { profiles.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Success Status'

      it 'returns list of users without authorized user' do
        expect(json['users'].size).to eq 2
        json['users'].each do |profile|
          expect(profile['id']).to_not eq me.id
        end
      end

      it 'does not return private fields' do
        json['users'].each do |profile|
          %w[ password encrypted_password ].each do |attr|
            expect(profile).to_not have_key(attr)
          end
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user_response) { json['user'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Success Status'

      it 'returns all public fields' do
        %w[ id email admin created_at updated_at ].each do |attr|
          expect(user_response[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[ password encrypted_password ].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end    
    end
  end
end