# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::SplashIntegrationsController, type: :controller do
  let(:token) { double acceptable?: true }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  let!(:application) { FactoryBot.create :application } # OAuth application
  let!(:user)        { FactoryBot.create :doorkeeper_testing_user }
  let!(:token)       { FactoryBot.create :access_token, application: application, resource_owner_id: user.id }

  let(:location) { Location.create user_id: user.id }

  describe 'testing the routes mostly' do
    context 'show action' do
      it 'should initialise an integration' do
        get :show, format: :json, params: { 
          location_id: location.slug
        }
        expect(response).to be_successful
        parsed = JSON.parse(response.body)
        expect(parsed['new_record']).to eq true
      end

      it 'should show an integration' do
        s = SplashIntegration.create location_id: location.id
        get :show, format: :json, params: { 
          location_id: location.slug
        }
        expect(response).to be_successful
        parsed = JSON.parse(response.body)
        expect(parsed['new_record']).to eq false
        expect(parsed['id']).to eq s.id
      end
    end

    context 'create action' do
      it 'should allow the user to create a splash integration' do
        post :create, format: :json, params: { location_id: location.slug, splash_integration: { username: 'username' } }
        expect(response).to be_successful

        s = SplashIntegration.last

        expect(s.username).to eq 'username'
        expect(s.location_id).to eq location.id
      end
    end

    context 'update action' do
      it 'should allow the user to update their integration' do
        s = SplashIntegration.create location_id: location.id
        patch :update, format: :json, params: { location_id: location.slug, id: s.id, splash_integration: { username: 'simon' } }
        expect(response).to be_successful
        expect(s.reload.username).to eq 'simon'
      end
    end

    context 'delete action' do
      it 'should allow the user to view their splash' do
        s = SplashIntegration.create location_id: location.id
        delete :destroy, format: :json, params: { location_id: location.slug, id: s.id }
        expect(response).to be_successful
      end
    end

    describe "custom actions" do
      context 'fetch sites action' do
        it 'should allow the user to create a splash integration' do
          s = SplashIntegration.create location_id: location.id, integration_type: 'unifi', host: 'https://1.2.3.4:8443'

          headers = { 'set-cookie': "csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly" }
          stub_request(:post, "https://1.2.3.4:8443/api/login").
            with(
              body: "{\"username\":null,\"password\":null}",
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type'=>'application/json',
                'User-Agent'=>'Faraday v0.15.1'
              }).
              to_return(status: 200, body: "", headers: headers)

          data = '{ "data" : [ { "_id" : "5a79c2e0ef0a7045891ad735" , "desc" : "Site 3" , "name" : "jcuq87bb" , "role" : "admin"} , { "_id" : "5a79c2e5ef0a7045891ad746" , "desc" : "Site 4" , "name" : "ja75u8cb" , "role" : "admin"} , { "_id" : "5a54f92bef0a81e2fb4d5317" , "desc" : "another site" , "name" : "4qqm5t2d" , "role" : "admin"} , { "_id" : "5a4fa885ef0a81e2fb4d52ea" , "attr_hidden_id" : "default" , "attr_no_delete" : true , "desc" : "Default" , "name" : "default" , "role" : "admin"} , { "_id" : "5a730d28ef0a7045891ad6ce" , "desc" : "11111" , "name" : "hycuz8ba" , "role" : "admin"} , { "_id" : "5a79c2d7ef0a7045891ad724" , "desc" : "Site 2" , "name" : "e8g5rn6t" , "role" : "admin"}] , "meta" : { "rc" : "ok"}}'
          data = JSON.parse data
          data = data.to_json

          stub_request(:get, "https://1.2.3.4:8443/api/self/sites").
            with(
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type'=>'application/json',
                'Cookie'=>'csrf_token=oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3; Path=/; Secure, unifises=e4JCiThbp4rocuwYIr6TZo3b1yC7hTFU; Path=/; Secure; HttpOnly',
                'Csrf-Token'=>'oJ63k2Ol84ZrjEQg8KuMZYFjvgrdFnl3',
                'User-Agent'=>'Faraday v0.15.1'
              }).
              to_return(status: 200, body: data, headers: {})

          get :fetch_settings, format: :json, params: { location_id: location.slug, id: s.id }
          expect(response).to be_successful
          parsed = JSON.parse response.body
          expect(parsed[0]['id']).to be_present
        end
      end
    end
  end
end
