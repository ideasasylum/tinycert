require 'tinycert/error'

RSpec.describe Tinycert::Request do
  let(:api_key) { 'ThisIsMySuperSecretAPIKey' }
  let(:url) { 'https://example.com' }
  let(:params) do
    {
      "token" => "d7dd6880c206216a9ed74f92ca8edaef88728bbb2c8b23020c624de9a7d08d6f",
      "ca_id" => 123,
      "CN" => "example.com",
      "O" => "ACME, Inc.",
      "OU" => "IT Department",
      "C" => "US",
      "ST" => "Illinois",
      "L" => "Chicago",
      "SANs[0][DNS]" => "www.example.com",
      "SANs[1][DNS]" => "example.com",
    }
  end
  let(:request) { Tinycert::Request.new api_key, url, params }

  describe 'response' do
    let(:fake_response) { double(code: code) }
    before(:each) do
      # Force the http client to return the fake response
      allow(request.instance_variable_get('@client')).to receive(:request).and_return fake_response
    end

    subject { request.response }

    context 'with a 200 code' do
      let(:code) { '200' }

      it 'should not raise an error' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with a 400 code' do
      let(:error_body) { {code: 'MyCode', text: 'My explanation'}.to_json }
      let(:fake_response) { double(code: code, body: error_body) }
      let(:code) { '400' }

      it 'should raise an error' do
        expect { subject }.to raise_error(Tinycert::Error, "400: MyCode - My explanation")
      end
    end
  end

  describe 'digest' do
    subject { request.digest }

    it { is_expected.to eq('16b436bd8779dadf0327a97eac54b631e02c4643cbf52ccc1358431691f74b21') }
  end

  describe 'build_request' do
    subject { request.build_request.body }

    # This is a test string frmo the Tinycert API documentation that does not
    # include the digest. Hence we'll create the fake using the params without the
    # digest in the request
    before(:each) do
      allow(request).to receive(:params_with_digest).and_return request.params
    end

    it { is_expected.to eq("C=US&CN=example.com&L=Chicago&O=ACME%2C+Inc.&OU=IT+Department&SANs%5B0%5D%5BDNS%5D=www.example.com&SANs%5B1%5D%5BDNS%5D=example.com&ST=Illinois&ca_id=123&token=d7dd6880c206216a9ed74f92ca8edaef88728bbb2c8b23020c624de9a7d08d6f") }
  end

  describe 'prepare_params' do
    let(:sorted_params) do
      {
        "C" => "US",
        "CN" => "example.com",
        "L" => "Chicago",
        "O" => "ACME, Inc.",
        "OU" => "IT Department",
        "SANs[0][DNS]" => "www.example.com",
        "SANs[1][DNS]" => "example.com",
        "ST" => "Illinois",
        "ca_id" => 123,
        "token" => "d7dd6880c206216a9ed74f92ca8edaef88728bbb2c8b23020c624de9a7d08d6f"
      }
    end
    subject { request.prepare_params(params).to_a }

    it { is_expected.to eq(sorted_params.to_a) }
  end
end
