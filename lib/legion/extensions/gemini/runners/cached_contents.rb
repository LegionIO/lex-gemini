# frozen_string_literal: true

module Legion
  module Extensions
    module Gemini
      module Runners
        module CachedContents
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)
          include Helpers::Usage

          def create(api_key:, model:, contents:, ttl: nil, expire_time: nil, display_name: nil, system_instruction: nil, **)
            client = Helpers::Client.new(api_key: api_key)
            body = client.create_cached_content(model: model, contents: contents, ttl: ttl, expire_time: expire_time,
                                                display_name: display_name, system_instruction: system_instruction)
            { result: body, usage: extract_usage(body) }
          end

          def list(api_key:, page_size: nil, page_token: nil, **)
            client = Helpers::Client.new(api_key: api_key)
            body = client.list_cached_contents(page_size: page_size, page_token: page_token)
            { result: body, usage: extract_usage(body) }
          end

          def get(api_key:, name:, **)
            client = Helpers::Client.new(api_key: api_key)
            body = client.get_cached_content(name: name)
            { result: body, usage: extract_usage(body) }
          end

          def update(api_key:, name:, ttl: nil, expire_time: nil, **)
            client = Helpers::Client.new(api_key: api_key)
            body = client.update_cached_content(name: name, ttl: ttl, expire_time: expire_time)
            { result: body, usage: extract_usage(body) }
          end

          def delete(api_key:, name:, **)
            client = Helpers::Client.new(api_key: api_key)
            body = client.delete_cached_content(name: name)
            { result: body, usage: extract_usage(body) }
          end
        end
      end
    end
  end
end
