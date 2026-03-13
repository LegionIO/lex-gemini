# frozen_string_literal: true

module Legion
  module Extensions
    module Gemini
      module Runners
        module Files
          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          def upload(api_key:, file_path:, mime_type:, display_name: nil, **)
            client = Helpers::Client.new(api_key: api_key)
            { result: client.upload_file(file_path: file_path, mime_type: mime_type, display_name: display_name) }
          end

          def list(api_key:, page_size: nil, page_token: nil, **)
            client = Helpers::Client.new(api_key: api_key)
            { result: client.list_files(page_size: page_size, page_token: page_token) }
          end

          def get(api_key:, name:, **)
            client = Helpers::Client.new(api_key: api_key)
            { result: client.get_file(name: name) }
          end

          def delete(api_key:, name:, **)
            client = Helpers::Client.new(api_key: api_key)
            { result: client.delete_file(name: name) }
          end
        end
      end
    end
  end
end
