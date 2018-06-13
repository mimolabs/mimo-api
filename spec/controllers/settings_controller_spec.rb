# frozen_string_literal: true

require 'rails_helper'

describe SettingsController, type: :controller do

  let!(:user) { FactoryBot.create :doorkeeper_testing_user }

  describe 'edit access' do
    it 'allows a logged in admin user' do
      sign_in user
      user.update role: 0

      settings = Settings.create business_name: 'hello', locale: 'en', logo: 'square-logo.png', favicon: 'favicon.ico'
      get :edit
      expect(response).to be_successful
    end

    it 'does not allow access when not logged in' do
      user.update role: 0

      settings = Settings.create business_name: 'hello', locale: 'en', logo: 'square-logo.png', favicon: 'favicon.ico'
      get :edit
      expect(response).not_to be_successful
    end

    it 'does not allow access when not admin' do
      sign_in user

      settings = Settings.create business_name: 'hello', locale: 'en', logo: 'square-logo.png', favicon: 'favicon.ico'
      expect { get :edit }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe 'update access' do
    it 'allows a logged in admin user to update' do
      sign_in user
      user.update role: 0

      settings = Settings.create business_name: 'hello', locale: 'en', logo: 'square-logo.png', favicon: 'favicon.ico'
      patch :update, params: { settings: { business_name: 'weasels' } }
      expect(response).to be_successful
      expect(Settings.find(settings.id).business_name).to eq 'weasels'
    end

    it 'does not allow updating when not logged in' do
      user.update role: 0

      settings = Settings.create business_name: 'hello', locale: 'en', logo: 'square-logo.png', favicon: 'favicon.ico'
      patch :update, params: { settings: { business_name: 'weasels' } }
      expect(response).not_to be_successful
      expect(Settings.find(settings.id).business_name).to eq 'hello'
    end

    it 'does not allow updating when not admin' do
      sign_in user

      settings = Settings.create business_name: 'hello', locale: 'en', logo: 'square-logo.png', favicon: 'favicon.ico'
      expect { patch :update, params: { settings: { business_name: 'weasels' } } }.to raise_error(Pundit::NotAuthorizedError)
    end
  end
end