# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SplashFileUploadsController, type: :controller do

  context 'logged in' do
    let(:token) { double acceptable?: true }

    before do
      allow(controller).to receive(:doorkeeper_token) { token }
    end

    let!(:application) { FactoryBot.create :application } # OAuth application
    let!(:user)        { FactoryBot.create :doorkeeper_testing_user }
    let!(:token)       { FactoryBot.create :access_token, application: application, resource_owner_id: user.id }

    describe '#create access' do
      it 'should allow someone to upload a splash image if logged in admin' do
        user.update role: 0
        sp = SplashPage.create
        post :create, format: :json, params: { splash_id: sp.id, splash: { background_image_name: 'a-cute-panda.jpg' } }
        expect(response).to be_successful
      end

      it 'should not allow upload because user is not admin' do
        sp = SplashPage.create
        post :create, format: :json, params: { splash_id: sp.id, splash: { background_image_name: 'a-cute-panda.jpg' } }
        expect(response).not_to be_successful
      end
    end
  end

  context 'not logged in' do
    let!(:application) { FactoryBot.create :application } # OAuth application

    describe '#create access' do
      it 'should not allow splash image upload - not logged in' do
        sp = SplashPage.create
        post :create, format: :json, params: { splash_id: sp.id, splash: { background_image_name: 'a-cute-panda.jpg' } }
        expect(response).not_to be_successful
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['message']).to eq '401 Unauthorized'
      end
    end
  end
end