# frozen_string_literal: true

module Legion
  module Extensions
    module Gemini
      module Runners
        module Tokens
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          def count(api_key:, contents:, model: 'gemini-2.0-flash', **)
            client = Helpers::Client.new(api_key: api_key, model: model)
            { result: client.count_tokens(contents: contents) }
          end
        end
      end
    end
  end
end
