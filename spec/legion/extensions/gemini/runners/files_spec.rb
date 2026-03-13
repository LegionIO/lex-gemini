# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::Files do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#upload' do
    let(:upload_response) { { 'file' => { 'name' => 'files/abc123' } } }

    it 'returns result hash with uploaded file info' do
      allow(client).to receive(:upload_file).and_return(upload_response)
      result = runner.upload(api_key: 'test-key', file_path: '/tmp/test.txt', mime_type: 'text/plain')
      expect(result).to eq({ result: upload_response })
    end
  end

  describe '#list' do
    let(:list_response) { { 'files' => [] } }

    it 'returns result hash with files list' do
      allow(client).to receive(:list_files).and_return(list_response)
      result = runner.list(api_key: 'test-key')
      expect(result).to eq({ result: list_response })
    end
  end

  describe '#get' do
    let(:file_response) { { 'name' => 'files/abc123', 'mimeType' => 'text/plain' } }

    it 'returns result hash with file metadata' do
      allow(client).to receive(:get_file).and_return(file_response)
      result = runner.get(api_key: 'test-key', name: 'files/abc123')
      expect(result).to eq({ result: file_response })
    end
  end

  describe '#delete' do
    it 'returns result hash with empty response' do
      allow(client).to receive(:delete_file).and_return({})
      result = runner.delete(api_key: 'test-key', name: 'files/abc123')
      expect(result).to eq({ result: {} })
    end
  end
end
