# frozen_string_literal: true

module Legion
  module Extensions
    module Gemini
      module Runners
        module Embeddings
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          def embed(api_key:, content:, model: 'gemini-embedding-exp', task_type: nil, title: nil, **)
            client = Helpers::Client.new(api_key: api_key, model: model)
            { result: client.embed_content(content: content, task_type: task_type, title: title) }
          end

          def batch_embed(api_key:, requests:, model: 'gemini-embedding-exp', **)
            client = Helpers::Client.new(api_key: api_key, model: model)
            { result: client.batch_embed_contents(requests: requests) }
          end
        end
      end
    end
  end
end
