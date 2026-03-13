# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::Models do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#list' do
    let(:models_response) { { 'models' => [{ 'name' => 'models/gemini-2.0-flash' }] } }

    it 'returns result hash with models' do
      allow(client).to receive(:list_models).and_return(models_response)
      result = runner.list(api_key: 'test-key')
      expect(result).to eq({ result: models_response })
    end
  end

  describe '#get' do
    let(:model_response) { { 'name' => 'models/gemini-2.0-flash', 'displayName' => 'Gemini 2.0 Flash' } }

    it 'returns result hash with model details' do
      allow(client).to receive(:get_model).and_return(model_response)
      result = runner.get(api_key: 'test-key', name: 'gemini-2.0-flash')
      expect(result).to eq({ result: model_response })
    end
  end
end
