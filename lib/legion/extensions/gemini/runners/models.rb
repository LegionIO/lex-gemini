# frozen_string_literal: true

module Legion
  module Extensions
    module Gemini
      module Runners
        module Models
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          def list(api_key:, **)
            client = Helpers::Client.new(api_key: api_key)
            { result: client.list_models }
          end

          def get(api_key:, name:, **)
            client = Helpers::Client.new(api_key: api_key)
            { result: client.get_model(name: name) }
          end
        end
      end
    end
  end
end
