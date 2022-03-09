require 'singleton'
require 'openssl'
require 'jwt'

class Jwk
  include Singleton

  def initialize
    @jwk = JWT::JWK.new(OpenSSL::PKey::RSA.new(2048), 'custom-kid')
  end

  def key
    @jwk
  end
end
