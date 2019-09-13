require 'rails_helper'

describe 'sign up a user', type: :request do
  it 'creates a User in the System and returns its data' do
    subject = attributes_for(:user)
    subject[:password_confirmation] = subject[:password]
    req = { user: subject }
    post '/api/v1/users', params: req
    expect(response.content_type).to eq('application/json; charset=utf-8')
    expect(JSON.parse(response.body)['status']).to eq('success')
  end
end
