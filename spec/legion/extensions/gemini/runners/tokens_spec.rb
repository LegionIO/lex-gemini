# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::Tokens do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }
  let(:zero_usage) { { input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0 } }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#count' do
    let(:token_response) { { 'totalTokens' => 10 } }

    it 'returns result hash with token count' do
      allow(client).to receive(:count_tokens).and_return(token_response)
      result = runner.count(api_key: 'test-key', contents: [{ parts: [{ text: 'Hello world' }] }])
      expect(result[:result]).to eq(token_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:count_tokens).and_return(token_response)
      result = runner.count(api_key: 'test-key', contents: [{ parts: [{ text: 'Hello world' }] }])
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage when response has no usageMetadata' do
      allow(client).to receive(:count_tokens).and_return(token_response)
      result = runner.count(api_key: 'test-key', contents: [{ parts: [{ text: 'Hello world' }] }])
      expect(result[:usage]).to eq(zero_usage)
    end
  end
end
