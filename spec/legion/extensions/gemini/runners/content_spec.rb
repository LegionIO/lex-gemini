# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::Content do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }
  let(:api_response) { { 'candidates' => [{ 'content' => { 'parts' => [{ 'text' => 'Hello!' }] } }] } }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#generate' do
    it 'returns result hash with API response' do
      allow(client).to receive(:generate_content).and_return(api_response)
      result = runner.generate(api_key: 'test-key', contents: [{ parts: [{ text: 'Hi' }] }])
      expect(result).to eq({ result: api_response })
    end

    it 'passes generation_config to client' do
      config = { temperature: 0.5 }
      allow(client).to receive(:generate_content).and_return(api_response)
      runner.generate(api_key: 'test-key', contents: [], generation_config: config)
      expect(client).to have_received(:generate_content).with(hash_including(generation_config: config))
    end
  end

  describe '#stream_generate' do
    it 'returns result hash with API response' do
      allow(client).to receive(:stream_generate_content).and_return(api_response)
      result = runner.stream_generate(api_key: 'test-key', contents: [{ parts: [{ text: 'Hi' }] }])
      expect(result).to eq({ result: api_response })
    end
  end
end
