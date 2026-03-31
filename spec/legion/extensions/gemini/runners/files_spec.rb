# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Runners::Files do
  let(:runner) { Object.new.extend(described_class) }
  let(:client) { instance_double(Legion::Extensions::Gemini::Helpers::Client) }
  let(:zero_usage) { { input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0 } }

  before do
    allow(Legion::Extensions::Gemini::Helpers::Client).to receive(:new).and_return(client)
  end

  describe '#upload' do
    let(:upload_response) { { 'file' => { 'name' => 'files/abc123' } } }

    it 'returns result hash with uploaded file info' do
      allow(client).to receive(:upload_file).and_return(upload_response)
      result = runner.upload(api_key: 'test-key', file_path: '/tmp/test.txt', mime_type: 'text/plain')
      expect(result[:result]).to eq(upload_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:upload_file).and_return(upload_response)
      result = runner.upload(api_key: 'test-key', file_path: '/tmp/test.txt', mime_type: 'text/plain')
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage' do
      allow(client).to receive(:upload_file).and_return(upload_response)
      result = runner.upload(api_key: 'test-key', file_path: '/tmp/test.txt', mime_type: 'text/plain')
      expect(result[:usage]).to eq(zero_usage)
    end
  end

  describe '#list' do
    let(:list_response) { { 'files' => [] } }

    it 'returns result hash with files list' do
      allow(client).to receive(:list_files).and_return(list_response)
      result = runner.list(api_key: 'test-key')
      expect(result[:result]).to eq(list_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:list_files).and_return(list_response)
      result = runner.list(api_key: 'test-key')
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage' do
      allow(client).to receive(:list_files).and_return(list_response)
      result = runner.list(api_key: 'test-key')
      expect(result[:usage]).to eq(zero_usage)
    end
  end

  describe '#get' do
    let(:file_response) { { 'name' => 'files/abc123', 'mimeType' => 'text/plain' } }

    it 'returns result hash with file metadata' do
      allow(client).to receive(:get_file).and_return(file_response)
      result = runner.get(api_key: 'test-key', name: 'files/abc123')
      expect(result[:result]).to eq(file_response)
    end

    it 'includes usage key in response' do
      allow(client).to receive(:get_file).and_return(file_response)
      result = runner.get(api_key: 'test-key', name: 'files/abc123')
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage' do
      allow(client).to receive(:get_file).and_return(file_response)
      result = runner.get(api_key: 'test-key', name: 'files/abc123')
      expect(result[:usage]).to eq(zero_usage)
    end
  end

  describe '#delete' do
    it 'returns result hash with empty response' do
      allow(client).to receive(:delete_file).and_return({})
      result = runner.delete(api_key: 'test-key', name: 'files/abc123')
      expect(result[:result]).to eq({})
    end

    it 'includes usage key in response' do
      allow(client).to receive(:delete_file).and_return({})
      result = runner.delete(api_key: 'test-key', name: 'files/abc123')
      expect(result).to have_key(:usage)
    end

    it 'returns zero usage' do
      allow(client).to receive(:delete_file).and_return({})
      result = runner.delete(api_key: 'test-key', name: 'files/abc123')
      expect(result[:usage]).to eq(zero_usage)
    end
  end
end
