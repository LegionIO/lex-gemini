# frozen_string_literal: true

module Legion
  module Extensions
    module Gemini
      module Runners
        module Embeddings
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
          include Helpers::Usage

          def embed(api_key:, content:, model: 'gemini-embedding-exp', task_type: nil, title: nil, **)
            client = Helpers::Client.new(api_key: api_key, model: model)
            body = client.embed_content(content: content, task_type: task_type, title: title)
            { result: body, usage: extract_usage(body) }
          end

          def batch_embed(api_key:, requests:, model: 'gemini-embedding-exp', **)
            client = Helpers::Client.new(api_key: api_key, model: model)
            body = client.batch_embed_contents(requests: requests)
            { result: body, usage: extract_usage(body) }
          end
        end
      end
    end
  end
end
