require 'rails_helper'

RSpec.describe 'users API', type: :request do
  # initialize test data
  let!(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }

  # Test suite for GET /users
  describe 'GET /users' do
    # make HTTP get request before each example
    before { get '/users' }

    it 'returns users' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /users/:id
  describe 'GET /users/:id' do
    before { get "/users/#{user_id}" }

    context 'when the record exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("{\"message\":\"Couldn't find User with 'id'=100\"}")
      end
    end
  end

  # Test suite for POST /users
  describe 'POST /users' do
    # valid payload
    let(:valid_attributes) { { first_name: 'Alejandro', second_name: 'Bartolo', last_name: 'Font', nickname: 'Barti', age: 21, email: 'alebart@gmail.com'} }

    context 'when the request is valid' do
      before { post '/users', params: valid_attributes }

      it 'creates a user' do
        expect(json['first_name']).to eq('Alejandro')
        expect(json['second_name']).to eq('Bartolo')
        expect(json['last_name']).to eq('Font')
        expect(json['nickname']).to eq('Barti')
        expect(json['age']).to eq(21)
        expect(json['email']).to eq('alebart@gmail.com')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end


    context 'when the request is valid but missing parameters' do
      before { post '/users', params: { nickname: 'Barti' } }

      it 'creates a user' do
        expect(json['first_name']).to eq('Alejandro')
        expect(json['second_name']).to eq('Bartolo')
        expect(json['last_name']).to eq('Font')
        expect(json['nickname']).to eq('Barti')
        expect(json['age']).to eq(21)
        expect(json['email']).to eq('alebart@gmail.com')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/users', params: { first_name: 'Marco' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("{\"message\":\"Validation failed: Nickname can't be blank\"}")
      end
    end
  end

  # Test suite for PUT /users/:id
  describe 'PUT /users/:id' do
    let(:valid_attributes) { { first_name: 'Mario' } }

    context 'when the record exists' do
      before { put "/users/#{user_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /users/:id
  describe 'DELETE /users/:id' do
    before { delete "/users/#{user_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end