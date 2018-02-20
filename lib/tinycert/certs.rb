module Tinycert
  class Certs
    attr_reader :ca

    EXPIRED =  1
    GOOD =  2
    REVOKED =  4
    HOLD =  8

    def initialize tinycert, ca
      @tinycert = tinycert
      @ca = ca
    end

    def expired
      list EXPIRED
    end

    def good
      list GOOD
    end

    def revoked
      list REVOKED
    end

    def hold
      list HOLD
    end

    def list what
      request = @tinycert.session_request 'https://www.tinycert.org/api/v1/cert/list', { ca_id: ca.id, what: what, token: @tinycert.token }
      request.results.collect { |c| Tinycert::Cert.new @tinycert, c }
    end

    def [](cert_id)
      request = @tinycert.session_request 'https://www.tinycert.org/api/v1/cert/details', { cert_id: cert_id, token: @tinycert.token }
      Tinycert::Cert.new @tinycert, results
    end

    def create name, c:'US', l:'', o:'', ou:'', st: '', names:[]
      # Include the common name in the SANs too
      all_names = names << name

      indexed_names = all_names.uniq.each_with_index.inject({}) { |names, (name, index)|
        names["SANs[#{index}][DNS]"] = name
        names
      }

      request = @tinycert.session_request 'https://www.tinycert.org/api/v1/cert/new', {
        token: @tinycert.token,
        CN: name,
        C: c,
        O: o,
        OU: ou,
        ST: st,
        ca_id: ca.id
       }.merge(indexed_names)
      Tinycert::Cert.new @tinycert, request.results
    end
  end
end
