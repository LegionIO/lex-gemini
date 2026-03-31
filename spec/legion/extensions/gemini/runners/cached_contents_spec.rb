# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::CachedContents do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }
  let(:zero_usage) { { input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0 } }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#create' do
    let(:cache_response) { { 'name' => 'cachedContents/abc', 'model' => 'models/gemini-2.0-flash' } }

    it 'returns result hash with cached content' do
      allow(client).to receive(:create_cached_content).and_return(cache_response)
      result = runner.create(api_key: 'test-key', model: 'gemini-2.0-flash', contents: [])
      expect(result[:result]).to eq(cache_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:create_cached_content).and_return(cache_response)
      result = runner.create(api_key: 'test-key', model: 'gemini-2.0-flash', contents: [])
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage when no usageMetadata' do
      allow(client).to receive(:create_cached_content).and_return(cache_response)
      result = runner.create(api_key: 'test-key', model: 'gemini-2.0-flash', contents: [])
      expect(result[:usage]).to eq(zero_usage)
    end
  end

  describe '#list' do
    let(:list_response) { { 'cachedContents' => [] } }

    it 'returns result hash with cached contents list' do
      allow(client).to receive(:list_cached_contents).and_return(list_response)
      result = runner.list(api_key: 'test-key')
      expect(result[:result]).to eq(list_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:list_cached_contents).and_return(list_response)
      result = runner.list(api_key: 'test-key')
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage' do
      allow(client).to receive(:list_cached_contents).and_return(list_response)
      result = runner.list(api_key: 'test-key')
      expect(result[:usage]).to eq(zero_usage)
    end
  end

  describe '#get' do
    let(:get_response) { { 'name' => 'cachedContents/abc' } }

    it 'returns result hash with cached content details' do
      allow(client).to receive(:get_cached_content).and_return(get_response)
      result = runner.get(api_key: 'test-key', name: 'cachedContents/abc')
      expect(result[:result]).to eq(get_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:get_cached_content).and_return(get_response)
      result = runner.get(api_key: 'test-key', name: 'cachedContents/abc')
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage' do
      allow(client).to receive(:get_cached_content).and_return(get_response)
      result = runner.get(api_key: 'test-key', name: 'cachedContents/abc')
      expect(result[:usage]).to eq(zero_usage)
    end
  end

  describe '#update' do
    let(:update_response) { { 'name' => 'cachedContents/abc', 'ttl' => '3600s' } }

    it 'returns result hash with updated cached content' do
      allow(client).to receive(:update_cached_content).and_return(update_response)
      result = runner.update(api_key: 'test-key', name: 'cachedContents/abc', ttl: '3600s')
      expect(result[:result]).to eq(update_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:update_cached_content).and_return(update_response)
      result = runner.update(api_key: 'test-key', name: 'cachedContents/abc', ttl: '3600s')
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage' do
      allow(client).to receive(:update_cached_content).and_return(update_response)
      result = runner.update(api_key: 'test-key', name: 'cachedContents/abc', ttl: '3600s')
      expect(result[:usage]).to eq(zero_usage)
    end
  end

  describe '#delete' do
    it 'returns result hash with empty response' do
      allow(client).to receive(:delete_cached_content).and_return({})
      result = runner.delete(api_key: 'test-key', name: 'cachedContents/abc')
      expect(result[:result]).to eq({})
    end

    it 'includes usage key in response' do
      allow(client).to receive(:delete_cached_content).and_return({})
      result = runner.delete(api_key: 'test-key', name: 'cachedContents/abc')
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage' do
      allow(client).to receive(:delete_cached_content).and_return({})
      result = runner.delete(api_key: 'test-key', name: 'cachedContents/abc')
      expect(result[:usage]).to eq(zero_usage)
    end
  end
end
