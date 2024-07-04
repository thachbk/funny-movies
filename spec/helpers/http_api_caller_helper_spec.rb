require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the HttpApiCallerHelper. For example:
#
# describe HttpApiCallerHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe HttpApiCallerHelper, type: :helper do
  describe '.parse_response' do
    subject { described_class.parse_response(response) }

    let(:response) { double('response', body: body) }
    let(:body) { '{"key": "value"}' }

    it { is_expected.to eq('key' => 'value') }

    context 'when response is not valid JSON' do
      let(:body) { 'invalid' }

      it { is_expected.to eq({}) }
    end

    context 'when response is nil' do
      let(:response) { nil }

      it { is_expected.to eq({}) }
    end
  end

  describe '.http_post' do
    subject { described_class.http_post(data, url) }

    let(:data) { { key: 'value' } }
    let(:url) { 'https://example.com/api/data' }
    let(:stubbed_response) { { message: 'Success' }.to_json }

    before do
      stub_request(:post, url)
        .with(body: data.to_json, headers: { 'Content-Type' => 'application/json' })
        .to_return(status: 200, body: stubbed_response, headers: {})
    end

    it { is_expected.to eq({ "message" => "Success" }) }
  end

  describe '.http_get' do
    subject { described_class.http_get(params, url) }

    let(:params) { { key: 'value' } }
    let(:url) { 'https://example.com/api/data' }
    let(:stubbed_response) { { message: 'Success' }.to_json }

    before do
      stub_request(:get, url)
        .with(query: params)
        .to_return(status: 200, body: stubbed_response, headers: {})
    end

    it { is_expected.to eq({ "message" => "Success" }) }
  end
end
