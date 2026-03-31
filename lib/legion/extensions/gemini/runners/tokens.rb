# frozen_string_literal: true

module Legion
  module Extensions
    module Gemini
      module Runners
        module Tokens
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
          include Helpers::Usage

          def count(api_key:, contents:, model: 'gemini-2.0-flash', **)
            client = Helpers::Client.new(api_key: api_key, model: model)
            body = client.count_tokens(contents: contents)
            { result: body, usage: extract_usage(body) }
          end
        end
      end
    end
  end
end
