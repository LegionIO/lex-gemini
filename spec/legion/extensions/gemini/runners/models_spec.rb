# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::Models do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }
  let(:zero_usage) { { input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0 } }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#list' do
    let(:models_response) { { 'models' => [{ 'name' => 'models/gemini-2.0-flash' }] } }

    it 'returns result hash with models' do
      allow(client).to receive(:list_models).and_return(models_response)
      result = runner.list(api_key: 'test-key')
      expect(result[:result]).to eq(models_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:list_models).and_return(models_response)
      result = runner.list(api_key: 'test-key')
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage' do
      allow(client).to receive(:list_models).and_return(models_response)
      result = runner.list(api_key: 'test-key')
      expect(result[:usage]).to eq(zero_usage)
    end
  end

  describe '#get' do
    let(:model_response) { { 'name' => 'models/gemini-2.0-flash', 'displayName' => 'Gemini 2.0 Flash' } }

    it 'returns result hash with model details' do
      allow(client).to receive(:get_model).and_return(model_response)
      result = runner.get(api_key: 'test-key', name: 'gemini-2.0-flash')
      expect(result[:result]).to eq(model_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:get_model).and_return(model_response)
      result = runner.get(api_key: 'test-key', name: 'gemini-2.0-flash')
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage' do
      allow(client).to receive(:get_model).and_return(model_response)
      result = runner.get(api_key: 'test-key', name: 'gemini-2.0-flash')
      expect(result[:usage]).to eq(zero_usage)
    end
  end
end
