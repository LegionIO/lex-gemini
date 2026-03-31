# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::Embeddings do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }
  let(:zero_usage) { { input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0 } }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#embed' do
    let(:embed_response) { { 'embedding' => { 'values' => [0.1, 0.2, 0.3] } } }

    it 'returns result hash with embedding' do
      allow(client).to receive(:embed_content).and_return(embed_response)
      result = runner.embed(api_key: 'test-key', content: { parts: [{ text: 'Hello' }] })
      expect(result[:result]).to eq(embed_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:embed_content).and_return(embed_response)
      result = runner.embed(api_key: 'test-key', content: { parts: [{ text: 'Hello' }] })
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage when response has no usageMetadata' do
      allow(client).to receive(:embed_content).and_return(embed_response)
      result = runner.embed(api_key: 'test-key', content: { parts: [{ text: 'Hello' }] })
      expect(result[:usage]).to eq(zero_usage)
    end
  end

  describe '#batch_embed' do
    let(:batch_response) { { 'embeddings' => [{ 'values' => [0.1] }] } }

    it 'returns result hash with embeddings' do
      allow(client).to receive(:batch_embed_contents).and_return(batch_response)
      result = runner.batch_embed(api_key: 'test-key', requests: [])
      expect(result[:result]).to eq(batch_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:batch_embed_contents).and_return(batch_response)
      result = runner.batch_embed(api_key: 'test-key', requests: [])
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage when response has no usageMetadata' do
      allow(client).to receive(:batch_embed_contents).and_return(batch_response)
      result = runner.batch_embed(api_key: 'test-key', requests: [])
      expect(result[:usage]).to eq(zero_usage)
    end
  end
end
