# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::Embeddings do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#embed' do
    let(:embed_response) { { 'embedding' => { 'values' => [0.1, 0.2, 0.3] } } }

    it 'returns result hash with embedding' do
      allow(client).to receive(:embed_content).and_return(embed_response)
      result = runner.embed(api_key: 'test-key', content: { parts: [{ text: 'Hello' }] })
      expect(result).to eq({ result: embed_response })
    end
  end

  describe '#batch_embed' do
    let(:batch_response) { { 'embeddings' => [{ 'values' => [0.1] }] } }

    it 'returns result hash with embeddings' do
      allow(client).to receive(:batch_embed_contents).and_return(batch_response)
      result = runner.batch_embed(api_key: 'test-key', requests: [])
      expect(result).to eq({ result: batch_response })
    end
  end
end
