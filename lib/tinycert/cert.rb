module Tinycert
  class Cert
    attr_reader :id, :status, :names, :cn

    def initialize tinycert, results
      @tinycert = tinycert
      parse_results results
    end

    CERT = "cert"
    CHAIN = "chain"
    CSR = "csr"
    KEY_DEC = "key.dec"
    KEY_ENC = "key.enc"
    PKCS12 = "pkcs12"

    def cert
      get CERT
    end

    def chain
      get CHAIN
    end

    def csr
      get CSR
    end

    def key_dec
      get KEY_DEC
    end

    def key_enc
      get KEY_ENC
    end

    def pkcs12
      get PKCS12
    end

    def get what
      request = @tinycert.session_request 'https://www.tinycert.org/api/v1/cert/get', { cert_id: id, what: what }
      request.results
    end

    def details
      request = @tinycert.session_request 'https://www.tinycert.org/api/v1/cert/details', { cert_id: id }
      parse_results request.results
      self
    end

    def revoke
      change_status 'revoked'
    end

    def change_status new_status
      request = @tinycert.session_request 'https://www.tinycert.org/api/v1/cert/status', {
        cert_id: id,
        status: new_status
      }
      request.results
    end

    def parse_results results
      @id = results['id']
      @status = results['status']
      @cn = results['CN']
      @name = results['name']
      @names = results.fetch('Alt', []).collect { |name| name['DNS'] }
    end
  end
end
