# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::CachedContents do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#create' do
    let(:cache_response) { { 'name' => 'cachedContents/abc', 'model' => 'models/gemini-2.0-flash' } }

    it 'returns result hash with cached content' do
      allow(client).to receive(:create_cached_content).and_return(cache_response)
      result = runner.create(api_key: 'test-key', model: 'gemini-2.0-flash', contents: [])
      expect(result).to eq({ result: cache_response })
    end
  end

  describe '#list' do
    let(:list_response) { { 'cachedContents' => [] } }

    it 'returns result hash with cached contents list' do
      allow(client).to receive(:list_cached_contents).and_return(list_response)
      result = runner.list(api_key: 'test-key')
      expect(result).to eq({ result: list_response })
    end
  end

  describe '#get' do
    let(:get_response) { { 'name' => 'cachedContents/abc' } }

    it 'returns result hash with cached content details' do
      allow(client).to receive(:get_cached_content).and_return(get_response)
      result = runner.get(api_key: 'test-key', name: 'cachedContents/abc')
      expect(result).to eq({ result: get_response })
    end
  end

  describe '#update' do
    let(:update_response) { { 'name' => 'cachedContents/abc', 'ttl' => '3600s' } }

    it 'returns result hash with updated cached content' do
      allow(client).to receive(:update_cached_content).and_return(update_response)
      result = runner.update(api_key: 'test-key', name: 'cachedContents/abc', ttl: '3600s')
      expect(result).to eq({ result: update_response })
    end
  end

  describe '#delete' do
    it 'returns result hash with empty response' do
      allow(client).to receive(:delete_cached_content).and_return({})
      result = runner.delete(api_key: 'test-key', name: 'cachedContents/abc')
      expect(result).to eq({ result: {} })
    end
  end
end
