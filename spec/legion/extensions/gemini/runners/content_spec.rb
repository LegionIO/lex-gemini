# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::Content do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }
  let(:api_response) do
    {
      'candidates'    => [{ 'content' => { 'parts' => [{ 'text' => 'Hello!' }] } }],
      'usageMetadata' => { 'promptTokenCount' => 10, 'candidatesTokenCount' => 5, 'totalTokenCount' => 15 }
    }
  end
  let(:zero_usage) { { input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0 } }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#generate' do
    it 'returns result and usage hash with API response' do
      allow(client).to receive(:generate_content).and_return(api_response)
      result = runner.generate(api_key: 'test-key', contents: [{ parts: [{ text: 'Hi' }] }])
      expect(result[:result]).to eq(api_response)
    end

    it 'includes usage with parsed token counts' do
      allow(client).to receive(:generate_content).and_return(api_response)
      result = runner.generate(api_key: 'test-key', contents: [{ parts: [{ text: 'Hi' }] }])
      expect(result[:usage]).to eq(
        input_tokens:       10,
        output_tokens:      5,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end

    it 'includes cache_read_tokens when cachedContentTokenCount is present' do
      cached_response = api_response.merge(
        'usageMetadata' => { 'promptTokenCount' => 20, 'candidatesTokenCount' => 8,
                             'cachedContentTokenCount' => 12, 'totalTokenCount' => 40 }
      )
      allow(client).to receive(:generate_content).and_return(cached_response)
      result = runner.generate(api_key: 'test-key', contents: [])
      expect(result[:usage]).to eq(
        input_tokens:       20,
        output_tokens:      8,
        cache_read_tokens:  12,
        cache_write_tokens: 0
      )
    end

    it 'returns zero usage when response has no usageMetadata' do
      allow(client).to receive(:generate_content).and_return({ 'candidates' => [] })
      result = runner.generate(api_key: 'test-key', contents: [])
      expect(result[:usage]).to eq(zero_usage)
    end

    it 'passes generation_config to client' do
      config = { temperature: 0.5 }
      allow(client).to receive(:generate_content).and_return(api_response)
      runner.generate(api_key: 'test-key', contents: [], generation_config: config)
      expect(client).to have_received(:generate_content).with(hash_including(generation_config: config))
    end
  end

  describe '#stream_generate' do
    it 'returns result and usage hash with API response' do
      allow(client).to receive(:stream_generate_content).and_return(api_response)
      result = runner.stream_generate(api_key: 'test-key', contents: [{ parts: [{ text: 'Hi' }] }])
      expect(result[:result]).to eq(api_response)
    end

    it 'includes usage with parsed token counts' do
      allow(client).to receive(:stream_generate_content).and_return(api_response)
      result = runner.stream_generate(api_key: 'test-key', contents: [])
      expect(result[:usage]).to eq(
        input_tokens:       10,
        output_tokens:      5,
        cache_read_tokens:  0,
        cache_write_tokens: 0
      )
    end

    it 'returns zero usage when response has no usageMetadata' do
      allow(client).to receive(:stream_generate_content).and_return({ 'candidates' => [] })
      result = runner.stream_generate(api_key: 'test-key', contents: [])
      expect(result[:usage]).to eq(zero_usage)
    end
  end
end
