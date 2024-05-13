# frozen_string_literal: true

module AuthorizationHelper
  def sign_in(user)
    auth_token = user.create_new_auth_token
    auth_cookie_value = {
      'access-token' => auth_token['access-token'],
      'token-type' => auth_token['token-type'],
      'client' => auth_token['client'],
      'expiry' => auth_token['expiry'],
      'uid' => auth_token['uid']
    }.to_json

    cookies['auth_cookie'] = auth_cookie_value
  end
end
