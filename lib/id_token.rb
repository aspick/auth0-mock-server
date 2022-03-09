require 'jwt'

class IdToken
  def initialize(ops)
    @payload = {
      sub: ENV['USER_ID'],
      iss: ENV['BASE_URL'],
      aud: ENV['AUTH0_CLIENT_ID'],
      iat: Time.now.to_i,
      exp: (Time.now + 3600).to_i
    }.merge(ops)
  end

  def to_s(jwk)
    JWT.encode @payload, jwk.keypair, 'RS256', {kid: jwk.kid}
  end
end
