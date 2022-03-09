require 'sinatra'
require 'json'
require 'securerandom'
require 'dotenv/load'

require_relative './lib/id_token'
require_relative './lib/store'
require_relative './lib/jwk'

set :bind, '0.0.0.0'
set :port, 3333

get '/authorize' do
  redirect_url = params['redirect_uri']
  state = params['state']
  nonce = params['nonce']
  code = SecureRandom.hex(12)

  codes = {
    code: code,
    nonce: nonce
  }

  Store.instance.save(codes)

  redirect redirect_url + "?code=#{code}&state=#{state}&nonce=#{nonce}"
end

post '/oauth/token' do
  code = params['code']
  codes = Store.instance.pop_by(code: code)

  id_token = IdToken.new(nonce: codes[:nonce]).to_s(Jwk.instance.key)
  {
    id_token: id_token,
    access_token: 'test-token'
  }.to_json
end

get '/.well-known/jwks.json' do
  {
    keys: [Jwk.instance.key.export]
  }.to_json
end

get '/.well-known/openid-configuration' do
  template = File.read(File.join(__dir__, 'assets', 'openid-configuration'))
  template.gsub('{{BASE_URL}}', ENV['BASE_URL'])
end

