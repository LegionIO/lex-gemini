# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Helpers::Client do
  subject(:client) { described_class.new(api_key: 'test-key', model: 'gemini-2.0-flash') }

  let(:success_response) { instance_double(Faraday::Response, success?: true, body: { 'candidates' => [] }) }
  let(:error_response) { instance_double(Faraday::Response, success?: false, body: { 'error' => 'bad request' }, status: 400) }

  before do
    allow(client.connection).to receive(:get).and_return(success_response)
    allow(client.connection).to receive(:post).and_return(success_response)
    allow(client.connection).to receive(:delete).and_return(success_response)
  end

  describe '#initialize' do
    it 'sets the api_key' do
      expect(client.api_key).to eq('test-key')
    end

    it 'sets the default model' do
      expect(client.model).to eq('gemini-2.0-flash')
    end

    it 'creates a faraday connection' do
      expect(client.connection).to be_a(Faraday::Connection)
    end
  end

  describe '#generate_content' do
    it 'returns response body on success' do
      result = client.generate_content(contents: [{ parts: [{ text: 'Hello' }] }])
      expect(result).to eq({ 'candidates' => [] })
    end

    it 'returns error hash on failure' do
      allow(client.connection).to receive(:post).and_return(error_response)
      result = client.generate_content(contents: [{ parts: [{ text: 'Hello' }] }])
      expect(result).to include(:error, :status)
    end
  end

  describe '#stream_generate_content' do
    it 'returns response body on success' do
      result = client.stream_generate_content(contents: [{ parts: [{ text: 'Hello' }] }])
      expect(result).to eq({ 'candidates' => [] })
    end
  end

  describe '#embed_content' do
    let(:embed_response) { instance_double(Faraday::Response, success?: true, body: { 'embedding' => { 'values' => [0.1] } }) }

    it 'returns embedding on success' do
      allow(client.connection).to receive(:post).and_return(embed_response)
      result = client.embed_content(content: { parts: [{ text: 'Hello' }] })
      expect(result).to include('embedding')
    end
  end

  describe '#batch_embed_contents' do
    let(:batch_response) { instance_double(Faraday::Response, success?: true, body: { 'embeddings' => [] }) }

    it 'returns embeddings on success' do
      allow(client.connection).to receive(:post).and_return(batch_response)
      result = client.batch_embed_contents(requests: [])
      expect(result).to include('embeddings')
    end
  end

  describe '#list_models' do
    let(:models_response) { instance_double(Faraday::Response, success?: true, body: { 'models' => [] }) }

    it 'returns models list' do
      allow(client.connection).to receive(:get).and_return(models_response)
      result = client.list_models
      expect(result).to include('models')
    end
  end

  describe '#get_model' do
    let(:model_response) { instance_double(Faraday::Response, success?: true, body: { 'name' => 'models/gemini-2.0-flash' }) }

    it 'returns model details' do
      allow(client.connection).to receive(:get).and_return(model_response)
      result = client.get_model(name: 'gemini-2.0-flash')
      expect(result).to include('name')
    end
  end

  describe '#count_tokens' do
    let(:token_response) { instance_double(Faraday::Response, success?: true, body: { 'totalTokens' => 5 }) }

    it 'returns token count' do
      allow(client.connection).to receive(:post).and_return(token_response)
      result = client.count_tokens(contents: [{ parts: [{ text: 'Hello' }] }])
      expect(result).to include('totalTokens')
    end
  end

  describe '#list_files' do
    let(:files_response) { instance_double(Faraday::Response, success?: true, body: { 'files' => [] }) }

    it 'returns files list' do
      allow(client.connection).to receive(:get).and_return(files_response)
      result = client.list_files
      expect(result).to include('files')
    end
  end

  describe '#get_file' do
    let(:file_response) { instance_double(Faraday::Response, success?: true, body: { 'name' => 'files/abc123' }) }

    it 'returns file metadata' do
      allow(client.connection).to receive(:get).and_return(file_response)
      result = client.get_file(name: 'files/abc123')
      expect(result).to include('name')
    end
  end

  describe '#delete_file' do
    let(:delete_response) { instance_double(Faraday::Response, success?: true, body: {}) }

    it 'returns empty body on success' do
      allow(client.connection).to receive(:delete).and_return(delete_response)
      result = client.delete_file(name: 'files/abc123')
      expect(result).to eq({})
    end
  end

  describe '#create_cached_content' do
    let(:cache_response) { instance_double(Faraday::Response, success?: true, body: { 'name' => 'cachedContents/abc' }) }

    it 'returns cached content' do
      allow(client.connection).to receive(:post).and_return(cache_response)
      result = client.create_cached_content(model: 'gemini-2.0-flash', contents: [])
      expect(result).to include('name')
    end
  end

  describe '#list_cached_contents' do
    let(:cache_list_response) { instance_double(Faraday::Response, success?: true, body: { 'cachedContents' => [] }) }

    it 'returns cached contents list' do
      allow(client.connection).to receive(:get).and_return(cache_list_response)
      result = client.list_cached_contents
      expect(result).to include('cachedContents')
    end
  end

  describe '#delete_cached_content' do
    let(:delete_response) { instance_double(Faraday::Response, success?: true, body: {}) }

    it 'returns empty body on success' do
      allow(client.connection).to receive(:delete).and_return(delete_response)
      result = client.delete_cached_content(name: 'cachedContents/abc')
      expect(result).to eq({})
    end
  end
end
