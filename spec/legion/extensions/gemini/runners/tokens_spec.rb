# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::Tokens do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#count' do
    let(:token_response) { { 'totalTokens' => 10 } }

    it 'returns result hash with token count' do
      allow(client).to receive(:count_tokens).and_return(token_response)
      result = runner.count(api_key: 'test-key', contents: [{ parts: [{ text: 'Hello world' }] }])
      expect(result).to eq({ result: token_response })
    end
  end
end
