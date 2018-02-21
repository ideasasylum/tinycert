require 'uri'
require 'net/http'
require 'openssl'
require 'json'

module Tinycert
  class Request
    attr_reader :params

    def initialize api_key, url, params
      @api_key = api_key
      @uri = URI(url)
      @params = prepare_params(params)

      # Create client
      @client = Net::HTTP.new(@uri.host, @uri.port)
      @client.use_ssl = true
      @client.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    # Sort the params consistently
    def prepare_params params
      results = {}
      # Build a new hash with string keys
      params.each { |k, v| results[k.to_s] = v }
      # Sort nested structures
      results.sort.to_h
    end

    def digest
      sorted_params = @params
      sorted_params_string = URI.encode_www_form(sorted_params)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @api_key, sorted_params_string)
    end

    # Create Request
    def build_request
      req = Net::HTTP::Post.new(@uri)
      req.add_field "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"
      req.body = URI.encode_www_form(params_with_digest)
      puts @uri
      puts req.body
      req
    end

    def params_with_digest
      params = @params.dup
      params['digest'] = digest
      params
    end

    # Fetch Request
    def response
      res = @client.request(build_request)
      raise Tinycert::Error.new(res) if res.code != '200'
      puts res.body
      res
    end

    def results
      results = JSON.parse(response.body)
      puts results
      results
    end
  end
end
