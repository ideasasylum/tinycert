require 'tinycert/error'

RSpec.describe Tinycert::Certs do
  describe 'create' do
    let(:tinycert) { double(Tinycert, token: '123') }
    let(:ca) { double(Tinycert::CertAuthority, id: 1) }
    let(:certs) { Tinycert::Certs.new tinycert, ca }
    let(:name) { 'www.example.com' }
    let(:names) { ['app.example.com', 'test.example.com'] }
    let(:fake_request) { double(Tinycert::Request, results: {}) }
    subject { certs.create name, names: names }

    it 'constructs the names parameters', :focus do
      expected_params = {
        CN: name,
        C: 'US',
        ca_id: 1,
        "SANs[0][DNS]"=>"app.example.com",
        "SANs[1][DNS]"=>"test.example.com",
        "SANs[2][DNS]"=>"www.example.com"
      }
      expect(tinycert).to receive(:session_request).with(anything(), expected_params).and_return fake_request
      subject
    end
  end
end
