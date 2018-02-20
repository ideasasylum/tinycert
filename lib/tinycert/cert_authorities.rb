module Tinycert
  class CertAuthorities
    def initialize tinycert
      @tinycert = tinycert
    end

    def create
    end

    def list
      request = @tinycert.session_request 'https://www.tinycert.org/api/v1/ca/list', { token: @tinycert.token }
      request.results.collect { |a| Tinycert::CertAuthority.new @tinycert, a }
    end

    def [](ca_id)
      list.find { |ca| ca.id == ca_id }
    end
  end
end
