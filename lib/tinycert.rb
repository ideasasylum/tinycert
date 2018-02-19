require 'pry'

require 'tinycert/request'
require 'tinycert/cert_authorities'
require 'tinycert/cert_authority'
require 'tinycert/certs'
require 'tinycert/cert'
require 'tinycert/error'

class TinyCert
  attr_reader :api_key, :email, :passphrase, :token

  def initialize email, passphrase, api_key
    @email = email
    @passphrase = passphrase
    @api_key = api_key
    @token = nil
  end

  def connect
    request = request 'https://www.tinycert.org/api/v1/connect', { email: email, passphrase: passphrase }
    @token = request.results['token']
  end

  def request url, params
    Tinycert::Request.new api_key, url, params
  end

  def session_request url, params
    connect unless token
    Tinycert::Request.new api_key, url, params.merge({token: token})
  end

  def authorities
    Tinycert::CertAuthorities.new(self)
  end


  def disconnect
  end
end
