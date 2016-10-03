Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_OAUTH_KEY'], ENV['FACEBOOK_OAUTH_SECRET'],
    scope: 'email,user_birthday,read_stream', display: 'popup'
end
