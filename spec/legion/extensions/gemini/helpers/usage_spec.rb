# frozen_string_literal: true

RSpec.describe Legion::Extensions::Gemini::Helpers::Usage do
  let(:host) { Object.new.extend(described_class) }

  describe '#extract_usage' do
    context 'when body contains usageMetadata with all fields' do
      let(:body) do
        {
          'usageMetadata' => {
            'promptTokenCount'        => 25,
            'candidatesTokenCount'    => 10,
            'cachedContentTokenCount' => 5,
            'totalTokenCount'         => 40
          }
        }
      end

      it 'returns correct input_tokens' do
        expect(host.extract_usage(body)[:input_tokens]).to eq(25)
      end

      it 'returns correct output_tokens' do
        expect(host.extract_usage(body)[:output_tokens]).to eq(10)
      end

      it 'returns correct cache_read_tokens' do
        expect(host.extract_usage(body)[:cache_read_tokens]).to eq(5)
      end

      it 'always returns zero cache_write_tokens' do
        expect(host.extract_usage(body)[:cache_write_tokens]).to eq(0)
      end
    end

    context 'when body contains usageMetadata without cachedContentTokenCount' do
      let(:body) do
        {
          'usageMetadata' => {
            'promptTokenCount'     => 15,
            'candidatesTokenCount' => 8,
            'totalTokenCount'      => 23
          }
        }
      end

      it 'returns correct input_tokens' do
        expect(host.extract_usage(body)[:input_tokens]).to eq(15)
      end

      it 'returns correct output_tokens' do
        expect(host.extract_usage(body)[:output_tokens]).to eq(8)
      end

      it 'defaults cache_read_tokens to zero' do
        expect(host.extract_usage(body)[:cache_read_tokens]).to eq(0)
      end
    end

    context 'when body has no usageMetadata' do
      it 'returns all zeros for a response hash without usageMetadata' do
        expect(host.extract_usage({ 'models' => [] })).to eq(
          input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0
        )
      end

      it 'returns all zeros for an empty hash' do
        expect(host.extract_usage({})).to eq(
          input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0
        )
      end
    end

    context 'when body is not a Hash' do
      it 'returns all zeros for nil' do
        expect(host.extract_usage(nil)).to eq(
          input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0
        )
      end

      it 'returns all zeros for an error hash with symbol keys' do
        expect(host.extract_usage({ error: 'bad request', status: 400 })).to eq(
          input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0
        )
      end
    end
  end
end
