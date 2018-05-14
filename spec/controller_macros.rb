module ControllerMacros

  def login_oauth
    before(:each) do
      pass = SecureRandom.hex
      @user ||= User.create(email: Faker::Internet.email, password: pass, password_confirmation: pass)
      create_oauth_credentials
    end
  end
  
  def create_oauth_credentials
    app = Doorkeeper::Application.new :name => 'test', :redirect_uri => 'https://localhost:8081'
    app.save!
    @oauth = OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
    @token = @oauth.password.get_token(@user.email, @user.password)
  end
end
