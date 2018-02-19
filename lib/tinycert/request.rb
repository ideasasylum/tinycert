require 'uri'
require 'net/http'
require 'openssl'
require 'json'
class Tinycert::Request
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
    # Sort nested structures
    # params.sort_by { |k,v| k.to_s }.to_h.each { |k, v| params[k] = v.sort.to_h if v.respond_to?(:sort) }
    params.sort.to_h
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
    # puts @uri
    # puts req.body
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
    res
  end

  def results
    results = JSON.parse(response.body)
    puts results
    results
  end
end
