# frozen_string_literal: true

module Legion
  module Extensions
    module Gemini
      module Runners
        module Models
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
          include Helpers::Usage

          def list(api_key:, **)
            client = Helpers::Client.new(api_key: api_key)
            body = client.list_models
            { result: body, usage: extract_usage(body) }
          end

          def get(api_key:, name:, **)
            client = Helpers::Client.new(api_key: api_key)
            body = client.get_model(name: name)
            { result: body, usage: extract_usage(body) }
          end
        end
      end
    end
  end
end
