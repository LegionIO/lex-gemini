# frozen_string_literal: true

module Legion
  module Extensions
    module Gemini
      module Helpers
        module Usage
          def extract_usage(body)
            return zero_usage unless body.is_a?(Hash)

            {
              input_tokens:       body.dig('usageMetadata', 'promptTokenCount') || 0,
              output_tokens:      body.dig('usageMetadata', 'candidatesTokenCount') || 0,
              cache_read_tokens:  body.dig('usageMetadata', 'cachedContentTokenCount') || 0,
              cache_write_tokens: 0
            }
          end

          private

          def zero_usage
            { input_tokens: 0, output_tokens: 0, cache_read_tokens: 0, cache_write_tokens: 0 }
          end
        end
      end
    end
  end
end
